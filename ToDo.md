Deploy from Content Library

* Get Authentication Token https://isjw.uk/powershell-and-rest-api-create-vm/
* List Libraries
* List Library Items
    * Identify OVF item
* Query OVF Package https://code.vmware.com/apis/62/vcenter-management#!/ovf%2Flibrary_item_/post_com_vmware_vcenter_ovf_library_item_id_ovf_library_item_id_~action_filter
    * Get Folder ID
    * Get Host ID
    * Get Resource Pool ID
* Deploy OVF Package https://code.vmware.com/apis/62/vcenter-management#!/ovf%2Flibrary_item_/post_com_vmware_vcenter_ovf_library_item_id_ovf_library_item_id_~action_deploy
    * Populate deployment_spec https://vdc-repo.vmware.com/vmwb-repository/dcr-public/d87b0863-0ebd-4ec7-b032-40398c7fded9/0acea89e-2bd1-4251-bf4c-b03275f964a7/VMware-vCloud-Suite-SDK-REST-6.0.0/docs/apidocs/structures/com/vmware/vcenter/ovf/LibraryItem/resource_pool_deployment_spec-structure.html
    * Populate target
    * 

