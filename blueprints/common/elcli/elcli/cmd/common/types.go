/* Copyright 2019 The ELIOT Authors.

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

package common

var (
	//Setup having option.
	Setup		string
	//Masters list
	Masters		[]string
	//Nodes list
	Nodes		[]string	
)

// InitOptions Strucutre
type InitOptions struct {
	KubernetesVersion  string
	DockerVersion      string
	K8SImageRepository string
	K8SPodNetworkCidr  string
}

//JoinOptions has the kubeedge cloud init information filled by CLI
type JoinOptions struct {
	InitOptions
	CertPath           string
	CloudCoreIP        string
	K8SAPIServerIPPort string
	EdgeNodeID         string
}

//InstallState enum set used for verifying a tool version is installed in host
type InstallState uint8

//Difference enum values for type InstallState
const (
	NewInstallRequired InstallState = iota
	AlreadySameVersionExist
	DefVerInstallRequired
	VersionNAInRepo
)

//ModuleRunning is defined to know the running status of KubeEdge components
type ModuleRunning uint8

//Different possible values for ModuleRunning type
const (
	NoneRunning ModuleRunning = iota
	KubeEdgeCloudRunning
	KubeEdgeEdgeRunning
)

//ToolsInstaller interface for tools with install and teardown methods.
type ToolsInstaller interface {
	InstallTools() error
	TearDown() error
}

//OSTypeInstaller interface for methods to be executed over a specified OS distribution type
type OSTypeInstaller interface {
	IsToolVerInRepo(string, string) (bool, error)
	IsDockerInstalled(string) (InstallState, error)
	InstallDocker() error
	IsK8SComponentInstalled(string, string) (InstallState, error)
	InstallK8S() error
	StartK8Scluster() error
	SetDockerVersion(string)
	SetK8SVersionAndIsNodeFlag(version string, flag bool)
	SetK8SImageRepoAndPodNetworkCidr(string, string)
	}

//FlagData stores value and default value of the flags used in this command
type FlagData struct {
	Val    interface{}
	DefVal interface{}
}
