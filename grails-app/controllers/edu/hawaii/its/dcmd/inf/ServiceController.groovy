/*
 * Copyright (c) 2014 University of Hawaii
 *
 * This file is part of DataCenter metadata (DCmd) project.
 *
 * DCmd is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * DCmd is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with DCmd.  It is contained in the DCmd release as LICENSE.txt
 * If not, see <http://www.gnu.org/licenses/>.
 */

package edu.hawaii.its.dcmd.inf

import grails.converters.JSON

class ServiceController {

    def serviceService
    def personService
    def generalService

    def static List<String> supportFilterHostList = new ArrayList()

    def scaffold = Service

    def save = {
//        params.id = params.objectId
        if(params.applicationSelect) {
            params.application = Application.get(params.applicationSelect)
        }

        if(params.environmentSelect) {
            params.env = generalService.createOrSelectEnv(params)
        }

        if(params.statusSelect) {
            params.status = generalService.createOrSelectStatus(params)
        }

        def serviceInstance = new Service(params)
        String saveOption = params.option //selects type of save to do

        if (serviceInstance.save(flush: true)) {
            if(params.personSelect) {
                def primarySA = generalService.createSupportRole(serviceInstance, Person.get(params.personSelect), 'Technical', RoleType.findByRoleName("Primary SA")?.id)
            }
            if(params.application) {
                generalService.inheritRoles(params.application)
            }

            //save options
            if (saveOption.equals("saveEdit")){
                flash.message = "${message(code: 'default.created.message', args: [message(code: 'service.label', default: 'Service'), serviceInstance.id])}"
                redirect(url: "/service/edit?id=${serviceInstance.id}")
            }
            else if (saveOption.equals("saveList")){
                flash.message = "${message(code: 'default.created.message', args: [message(code: 'service.label', default: 'Service'), serviceInstance.id])}"
                redirect(url: "/service/list")
            }
            else if (saveOption.equals("saveCreate")){
                flash.message = "${message(code: 'default.created.message', args: [message(code: 'service.label', default: 'Service'), serviceInstance.id])}"
                redirect(url: "/service/create")
            }
            else{
                flash.message = "${message(code: 'default.created.message', args: [message(code: 'service.label', default: 'Service'), serviceInstance.id])}"
                redirect(url: "/service/show?id=${serviceInstance.id}")
            }
         /*   flash.message = "${message(code: 'default.created.message', args: [message(code: 'service.label', default: 'Service'), serviceInstance.id])}"
            redirect(url: "/service/show?id=${serviceInstance.id}")*/
        }
        else {
            render(view: "create", model: [serviceInstance: serviceInstance])

        }
    }
    //save options redirected to master save action
    def saveEdit = {
        String saveType;
        forward action: "save", params: [option: "saveEdit"]
    }

    def saveList = {
        String saveType;
        forward action: "save", params: [option: "saveList"]
    }

    def saveCreate = {
        String saveType;
        forward action: "save", params: [option: "saveCreate"]
    }

    def discard = {
        redirect(action:"create")
    }

    def update = {
        //get the instance being updated
        System.out.println(params)

        def serviceInstance = Service.get(params.id)

        if(params.applicationSelect)
            params.application = Application.get(params.applicationSelect)

        if(params.environmentSelect) {
            params.env = generalService.createOrSelectEnv(params)
        }

        if(params.statusSelect) {
            params.status = generalService.createOrSelectStatus(params)
        }

        if (serviceInstance) {
            serviceInstance.properties = params

            //save and redirect
            if (!serviceInstance.hasErrors() && serviceInstance.save(flush: true)) {
                flash.message = "${message(code: 'default.updated.message', args: [message(code: 'service.label', default: 'Service'), serviceInstance.id])}"
                redirect(url: "/service/show?id=${serviceInstance.id}")
            } else {
                render(view: "edit", model: [serviceInstance: serviceInstance])
            }

            //asset not found; no edits can be performed; show the list
        } else {
            flash.message = "${message(code: 'default.not.found.message', args: [message(code: 'service.label', default: 'Service'), params.id])}"
            redirect(action: "list")
        }
    }

    def delete = {
        def error = false
        System.out.println(params)
        def item = Service.get(params.id.toLong())
        def theApp = item.application
        def tiers = TierDependency.createCriteria().list() {
            like('service.id', item.id)
            eq('serviceInstance', true)
            projections {
                distinct("tier")
            }
        }
//        System.out.println(tiers)
        tiers.each { tier ->
            if(!error) {
                if (!tier.hasErrors()) {
                    tier.delete()
                }
                else {
                    System.out.println(tier.errors.fieldError)
                    error = true
                }
            }
        }
        if (!error) {
            item.delete()
            if (theApp)
                redirect(url: "/application/show?id=${theApp.id}")
            else
                redirect(action:'list')
        }
    }

    /*****************************************************************/
    /* Main Service List Grid
    /*****************************************************************/

   /* def listAll = {

        def jsonData = serviceService.listAll(params)
        render jsonData as JSON
    } */

    def listAllService = {
        params.supportFilterHostList = supportFilterHostList
        def jsonData = serviceService.listAllService(params)
        render jsonData as JSON
    }

    def listAllSubGrid = {

        def jsonData = serviceService.listAllSubGrid(params)
        render jsonData as JSON
    }

    def listAllSubSubGrid = {
        def jsonData = serviceService.listAllSubSubGrid(params)
        render jsonData as JSON
    }

    def exportListAll = {
        params.rows = Integer.MAX_VALUE
       params.supportFilterHostList = supportFilterHostList

        def jsonData = serviceService.listAllService(params)
        def theList = []
        jsonData.rows.each { theRow ->
            for(def i=0; i<7; i++) {
                if(!theRow.cell[i]) theRow.cell[i]=""
            }
            /*
            if(!theRow.cell[1]) theRow.cell[1] = ""
            if(!theRow.cell[2]) theRow.cell[2] = ""
            if(!theRow.cell[6]) theRow.cell[6] = ""
            if(!theRow.cell[8]) theRow.cell[8] = ""
            if(!theRow.cell[9]) theRow.cell[9] = ""
            if(!theRow.cell[11]) theRow.cell[11] = ""
            if(!theRow.cell[12]) theRow.cell[12] = ""
            */
            def tempVals = [
                    'Service Name': theRow.cell[0].replaceAll("\\<.*?>",""),
                    'Application': theRow.cell[1],
                    'Environment': theRow.cell[2],
                    'Service Description':theRow.cell[3].replaceAll("\\<.*?>",""),
                    'Status': theRow.cell[4].replaceAll("\\<.*?>",""),
                    'Service Admin': theRow.cell[5],
                    'App Admin': theRow.cell[6],
                    'General Notes': theRow.cell[7],
            ]

            theList.add(tempVals)
        }

        render theList as JSON
    }

    /*****************************************************************/
    /* Autocomplete Functions
    /*****************************************************************/

    def envList = {
        render generalService.envList(params) as JSON
    }


    /*****************************************************************/
    /* Tiers Grid
    /*****************************************************************/

    def listTierDependencies = {
        def jsonData = serviceService.listTierDependencies(params)
        render jsonData as JSON
    }

    def editTierDependencies = {
        def response = serviceService.editTierDependencies(params)
        render response as JSON
    }

    def listTierSubGrid = {
        def response = serviceService.listTiersSubGrid(params)
        render response as JSON
    }


    /*****************************************************************/
    /* Dependency Grid
    /*****************************************************************/
    def listSoftwareDependencies = {
        def serviceDependencyList = serviceService.listServiceDependencies(params)
        render serviceDependencyList as JSON
    }

    def editSoftwareDependencies = {
        def response = serviceService.editServiceDependencies(params)
        render response as JSON
    }

    def generateName = {
        def currentService = Service.get(params.serviceId)
            def count = TierDependency.createCriteria().count {
            eq('service.id', currentService.id)
            eq('serviceInstance', true)
        }
        def response = [retVal:true, generatedName: "${currentService.serviceTitle} Instance ${count+1}"]
        render response as JSON
    }



    /*****************************************************************/
    /* Listing methods
    /*****************************************************************/

    def listServicesAsSelect = {
        def response = serviceService.listServicesAsSelect()
        render response
    }

    def listServicesOfAppAsSelect={
        System.out.println(params.appId.toLong())
        def service = Service.createCriteria().list() {
            eq('application.id', params.appId.toLong())
        }
        def theList = []

        service.each {
            def tmp = [id:"${it.id}", text: it.serviceTitle]
            theList.add(tmp)
        }
        def jsonData = [retVal: true, theList: theList]
        render jsonData as JSON
    }

    def getServiceDetails = {
        System.out.println(params)
        def service = Service.get(params.serviceId)
        //render service as JSON
        def response = [retVal: true,
                        serviceTitle:service.serviceTitle,
                        env:service.env?.abbreviation,
                        id:service.id,
                        serviceDescription:service.serviceDescription,
                        status:service.status?.abbreviation,
                        dateCreated:service.dateCreated,
                        lastUpdated:service.lastUpdated]
        render response as JSON
    }

    def getAssetDetails = {
        System.out.println(params)
        def asset = Asset.get(params.id)
        render asset as JSON

    }

    def getEnvironmentsAsSelect = {
        def theList = []
        Environment.getAll().each { environment ->
            theList.add(['id':environment.id, 'text':environment.abbreviation])
        }
        render theList as JSON
    }

    def getStatusesAsSelect = {
        def theList = []
        theList.add(['id':'Available', 'text':'Available'])
        theList.add(['id':'Problem', 'text':'Problem'])
        theList.add(['id':'Maintenance', 'text':'Maintenance'])
        theList.add(['id':'Offline', 'text':'Offline'])

        render theList as JSON
    }

    def clearSupportFileFilter = {
        supportFilterHostList = []
        def response = [state: "OK", id: 1]
        render response as JSON
    }

}


