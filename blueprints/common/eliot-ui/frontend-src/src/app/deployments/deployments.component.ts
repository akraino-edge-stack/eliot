import { Component, OnInit, TemplateRef } from '@angular/core';
import { EliotserviceService } from '../eliotservice.service';
import { deploymentData, nodeDeploy } from '../datainterface';
import { FormBuilder, FormGroup } from '@angular/forms';
import { ToolbarService } from './../toolbar/toolbar.service';
import {MatTableDataSource} from '@angular/material/table';

import { YAML } from 'yaml';

import { ToastService } from './toast.service';

@Component({
  selector: 'app-deployments',
  templateUrl: './deployments.component.html',
  styleUrls: ['./deployments.component.scss']
})
export class DeploymentsComponent implements OnInit {
  host: {'[class.ngb-toasts]': 'true'}
  isLinear = false;
  fileContent: string = '';
  deployParam = false;

  isTemplate(toast) { return toast.textOrTpl instanceof TemplateRef; }
  fileData: File = null;
  previewFile: any = null;
  deployData = {} as deploymentData;
  uploadForm: FormGroup;
  deployForm: FormGroup;
  typePanelOpenState = false;

  nodeSelected: string;
  nodesArray: string[];
  nodes: string[] = [];
  nodeLabelMentioned: string;

  nodeDetails = {} as nodeDeploy;

  constructor(
    private serviceobj: EliotserviceService,
    private formBuilder: FormBuilder,
    public toolbarService: ToolbarService,
    public toastService: ToastService
  ) { }

  ngOnInit() {
    this.toolbarService.show();
    this.typePanelOpenState = false;
    this.uploadForm = this.formBuilder.group(
      {
        yamlfile: [''],
        sample: [''],
      }
    );
    this.deployForm = this.formBuilder.group(
      {
        // sampleone: [''],
        // sampletwo: [''],
        // samplethree: [''],
        // samplefour: [''],
        deployyamlfile: ['']
      }
    );
    
    this.getNodes();
    
  }

  fileProgress(event) {
    debugger;
    
    if(event.target.files.length > 0 ){
      const deployfile = event.target.files[0];
      let filee = event.target.files[0];
      // this.uploadForm.get('yamlfile').setValue(file);
      this.deployForm.get('deployyamlfile').setValue(deployfile);
      // this.uploadForm.get('sample');
      debugger;
      // var reader = new FileReader();
      // reader.readAsDataURL(deployfile);
      let filecon: string = '';
      // reader.onload = (_event) => {
      //   // this.previewFile = reader.result;
      //   this.previewFile = reader.readAsText.toString;

      //   console.log("Preview File");
      //   console.log(this.previewFile);
      // }
      
      let fileReader: FileReader = new FileReader();
      
      // fileReader.onloadend = function(x) {
      //   // fileContent = fileReader.result;
      //   fileReader.result;
      // }
      // fileReader.readAsText(deployfile);
      debugger;
      console.log(YAML.parse(deployfile));
      debugger;
      
      // this.fileContent = fileReader.result.toString;

    }

    
    console.log("Inside fileProgress...")
    // this.fileData = <File>fileInput.target.files[0];
    // console.log(this.fileData);
  }
 
  onSubmit() {
    console.log("Inside onSubmit() ....")
    const formData = new FormData();

    // formData.append('file',this.uploadForm.get('yamlfile').value);
    // formData.append('sss',this.deployForm.get('sampleone').value);
    // formData.append('ssa',this.deployForm.get('sampletwo').value);
    // formData.append('ssb',this.deployForm.get('samplethree').value);
    // formData.append('ssc',this.deployForm.get('samplefour').value);
    formData.append('deployfile',this.deployForm.get('deployyamlfile').value);
    // formData.append('sample',this.formBuilder.)
    debugger;
    // this.deployData.deployFile = formData.get('yamlfile');
    // this.deployData.deployFile = formData.get('deployyamlfile');
    this.deployData.deployFile = this.deployForm.value.deployyamlfile;
    console.log("deploydata...");
    console.log(this.deployData);
    console.log("formData....");
    console.log(formData);
    // formData.append('file', this.fileData);
    // this.deployData.deployFile = formData.get('yamlfile')
    console.log(this.deployForm.value);
    debugger;
    this.serviceobj.postDeploymentPackage(formData)
        .subscribe(data => {
          console.log(data);
          this.showSuccess();
          // console.log(data);
        }
      ,error => console.log(error)
      );
    // this.http.post('url/to/your/api', formData)
    //   .subscribe(res => {
    //     console.log(res);
    //     alert('SUCCESS !!');
    //   })
    // this.showSuccess();
  }

  showSuccess() {
    this.toastService.show('Application ( csar ) package uploaded Successfully', { classname: 'bg-success text-light', delay: 10000 });
  }

  deploySuccess() {
    this.deployParam = true;
    this.serviceobj.postDeployRequest(this.deployParam,this.nodeDetails)
        .subscribe(data => {
          console.log(data);
          this.toastService.show('ELIOT IOT Application / Yaml deployed Successfully', { classname: 'bg-success text-light', delay: 10000 });
        }
      ,error => console.log(error)
    );

    
  }

  getNodes() {
    this.serviceobj.getNodesArray()
       .subscribe(data => {
        debugger;
        console.log(data);
        data.nodesArray.forEach(
          nodeData => {
            debugger;
            this.nodes.push(nodeData.value);
            
        });
        
        // this.sessionArr.forEach(data => {
        //   if (data.month == m) {
        //     this.january.push(data);
        //     this.historyDataSource = new MatTableDataSource(this.january);
        //   }
        // })
        
        console.log(this.nodesArray);
        debugger;
        // this.nodewise = data;
        // this.nodesArray = this.nodewise.nodesArray;
       },
       error => console.log(error));
  }

  addNodeDetails() {
    this.nodeDetails.deployNodeLabel = this.nodeLabelMentioned;
    debugger;
    this.nodeDetails.deployNodeName = this.nodeSelected;
  }
}
