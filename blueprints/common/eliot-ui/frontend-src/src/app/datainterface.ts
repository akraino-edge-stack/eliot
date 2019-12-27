export interface nodeDetailss {
    nodeName: string;
    position: number;
    role: string;
    nodeStatus: string;
}

export interface nodeDetails {
    eliotNodes: nodinfo[];
}

export interface nodinfo {
  nodeName: string;
  nodeStatus: string;
  nodeRole: string;
  age: string;
  version: string;
  internalIp: string;
  externalIp: string;
  osImage: string;
  kernel: string;
  containerRuntime: string;
}

export interface podNamespace {
  podNamespaces: string[];
}

export interface podDetails {
  eliotPods: podinfo[];
}

export interface podinfo {
  namespace: string;
  name: string;
  ready: string;
  status: string;
  restarts: string;
  age: string;
  ip: string;
  node: string;
  nominated: string;
  readiness: string;
}

export interface uninstallinfo {
  id: string;
  appName: string;
  nodeIp: string;
  date: string;
  runningStatus: string;
}

export interface currentDeployDetails {
  currentDeployArray: currentDeployInfo[];
}

export interface currentDeployInfo {
  deployId: string;
  appName: string;
  yamlName: string;
  nodeIp: string;
  runningStatus: string;
}


export interface nodesDropDownDetails {
  nodesArray: nodesDropDown[];
}

export interface nodesDropDown {
  value: string;
  viewValue: string;
}

export interface serviceDetails {
  eliotServices: serviceinfo[];
}

export interface serviceinfo {
  serviceName: string;
  serviceType: string;
  clusterIp: string;
  externalIp: string;
  ports: string;
  age: string;
  selector: string;
}

export interface deploymentData {
  deployFile: any;
}

export interface historyDetails {
  eliotHistory: historyInformation[];
}

export interface historyinfo {
  namespace: string;
  name: string;
}

export interface historyInformation {
  id: string;
  date: string;
  csarPackage: string;
  yamlFile: string;
  month: string;
  status: string;
}

export interface historyPostInfo {
  fileDownload: fileDownload[];
}

export interface fileDownload {
  id: string;
  fileName: string;
}

export interface nodeDeploy {
  deployNodeName: string;
  deployNodeLabel: string;
}


export interface dashboardInfo {
  appDeployStatus: appDeployStatus;
  stabilityStatus: stabilityStatus;
  historyStatus: historyStatus;
}

export interface appDeployStatus {
  deploySuccess: number;
  deployFailed: number;
  deployPending: number;
}

export interface stabilityStatus {
  nodesStable: number;
  nodesUnstable: number;
  podsStable: number;
  podsUnstable: number;
  servicesRunning: number;
}

export interface historyStatus {
  jan: number;
  feb: number;
  mar: number;
  apr: number;
  may: number;
  jun: number;
  jul: number;
  aug: number;
  sep: number;
  oct: number;
  nov: number;
  dec: number;
}