/*
Copyright 2019 The Kubeedge Authors.

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

package util

import (
	"fmt"
	//"os"
	"os/exec"
	"strings"

	//types "github.com/kubeedge/kubeedge/keadm/app/cmd/common"
	types "elcli/cmd/common"
)

const downloadRetryTimes int = 3

// Ubuntu releases
const (
	UbuntuXenial = "xenial"
	UbuntuBionic = "bionic"
)

//UbuntuOS struct objects shall have information of the tools version to be installed
//on Hosts having Ubuntu OS.
//It implements OSTypeInstaller interface
type UbuntuOS struct {
	DockerVersion     string
	KubernetesVersion string
	KubeEdgeVersion   string
	IsEdgeNode        bool //True - Edgenode False - EliotCloudnode
	K8SImageRepository string
	K8SPodNetworkCidr  string
}

//SetDockerVersion sets the Docker version for the objects instance
func (u *UbuntuOS) SetDockerVersion(version string) {
	u.DockerVersion = version
}

//SetK8SVersionAndIsNodeFlag sets the K8S version for the objects instance
//It also sets if this host shall act as edge node or not
func (u *UbuntuOS) SetK8SVersionAndIsNodeFlag(version string, flag bool) {
	u.KubernetesVersion = version
	u.IsEdgeNode = flag
}

//SetK8SImageRepoAndPodNetworkCidr sets the K8S image Repository and pod network
// cidr.
func (u *UbuntuOS) SetK8SImageRepoAndPodNetworkCidr(repo, cidr string) {
	u.K8SImageRepository = repo
	u.K8SPodNetworkCidr = cidr
}

//SetKubeEdgeVersion sets the KubeEdge version for the objects instance
func (u *UbuntuOS) SetKubeEdgeVersion(version string) {
	u.KubeEdgeVersion = version
}

//IsToolVerInRepo checks if the tool mentioned in available in OS repo or not
func (u *UbuntuOS) IsToolVerInRepo(toolName, version string) (bool, error) {
	//Check if requested Docker or K8S components said version is available in OS repo or not

	chkToolVer := fmt.Sprintf("apt-cache madison '%s' | grep -w %s | head -1 | awk '{$1=$1};1' | cut -d' ' -f 3", toolName, version)
	cmd := &Command{Cmd: exec.Command("sh", "-c", chkToolVer)}
	cmd.ExecuteCommand()
	stdout := cmd.GetStdOutput()
	errout := cmd.GetStdErr()

	if errout != "" {
		return false, fmt.Errorf("%s", errout)
	}

	if stdout != "" {
		fmt.Println(toolName, stdout, "is available in OS repo")
		return true, nil
	}

	fmt.Println(toolName, "version", version, "not found in OS repo")
	return false, nil
}

func (u *UbuntuOS) addDockerRepositoryAndUpdate() error {
	//lsb_release -cs
	cmd := &Command{Cmd: exec.Command("sh", "-c", "lsb_release -cs")}
	cmd.ExecuteCommand()
	distVersion := cmd.GetStdOutput()
	if distVersion == "" {
		return fmt.Errorf("ubuntu dist version not available")
	}
	fmt.Println("Ubuntu distribution version is", distVersion)

	//'apt-get update'
	stdout, err := runCommandWithShell("apt-get update")
	if err != nil {
		return err
	}
	fmt.Println(stdout)

	//"curl -fsSL \"$DOWNLOAD_URL/linux/$lsb_dist/gpg\" | apt-key add"
	//Get the GPG key
	curl := fmt.Sprintf("curl -fsSL \"%s/linux/%s/gpg\" | apt-key add", DefaultDownloadURL, UbuntuOSType)
	cmd = &Command{Cmd: exec.Command("sh", "-c", curl)}
	cmd.ExecuteCommand()
	curlOutput := cmd.GetStdOutput()
	if curlOutput == "" {
		return fmt.Errorf("not able add the apt key")
	}
	fmt.Println(curlOutput)

	//Add the repo in OS source.list
	aptRepo := fmt.Sprintf("deb [arch=$(dpkg --print-architecture)] %s/linux/%s %s stable", DefaultDownloadURL, UbuntuOSType, distVersion)
	updtRepo := fmt.Sprintf("echo \"%s\" > /etc/apt/sources.list.d/docker.list", aptRepo)
	cmd = &Command{Cmd: exec.Command("sh", "-c", updtRepo)}
	cmd.ExecuteCommand()
	updtRepoErr := cmd.GetStdErr()
	if updtRepoErr != "" {
		return fmt.Errorf("not able add update repo due to error : %s", updtRepoErr)
	}

	//Do an apt-get update
	stdout, err = runCommandWithShell("apt-get update")
	if err != nil {
		return err
	}
	fmt.Println(stdout)

	return nil
}

//IsDockerInstalled checks if docker is installed in the host or not
func (u *UbuntuOS) IsDockerInstalled(defVersion string) (types.InstallState, error) {
	cmd := &Command{Cmd: exec.Command("sh", "-c", "docker -v | cut -d ' ' -f3 | cut -d ',' -f1")}
	cmd.ExecuteCommand()
	str := cmd.GetStdOutput()

	if strings.Contains(str, u.DockerVersion) {
		return types.AlreadySameVersionExist, nil
	}

	if err := u.addDockerRepositoryAndUpdate(); err != nil {
		return types.VersionNAInRepo, err
	}

	if str == "" {
		return types.NewInstallRequired, nil
	}

	isReqVerAvail, err := u.IsToolVerInRepo("docker-ce", u.DockerVersion)
	if err != nil {
		return types.VersionNAInRepo, err
	}

	var isDefVerAvail bool
	if u.DockerVersion != defVersion {
		isDefVerAvail, err = u.IsToolVerInRepo("docker-ce", defVersion)
		if err != nil {
			return types.VersionNAInRepo, err
		}
	}

	if isReqVerAvail {
		return types.NewInstallRequired, nil
	}

	if isDefVerAvail {
		return types.DefVerInstallRequired, nil
	}

	return types.VersionNAInRepo, nil
}

//InstallDocker will install the specified docker in the host
func (u *UbuntuOS) InstallDocker() error {
	fmt.Println("Installing ", u.DockerVersion, "version of docker")

	//Do an apt-get install
	instPreReq := fmt.Sprintf("apt-get install -y %s", DockerPreqReqList)
	stdout, err := runCommandWithShell(instPreReq)
	if err != nil {
		return err
	}
	fmt.Println(stdout)

	//Get the exact version string from OS repo, so that it can search and install.
	chkDockerVer := fmt.Sprintf("apt-cache madison 'docker-ce' | grep %s | head -1 | awk '{$1=$1};1' | cut -d' ' -f 3", u.DockerVersion)
	cmd := &Command{Cmd: exec.Command("sh", "-c", chkDockerVer)}
	cmd.ExecuteCommand()
	stdout = cmd.GetStdOutput()
	errout := cmd.GetStdErr()
	if errout != "" {
		return fmt.Errorf("%s", errout)
	}

	fmt.Println("Expected docker version to install is", stdout)

	//Install docker-ce
	dockerInst := fmt.Sprintf("apt-get install -y --allow-change-held-packages --allow-downgrades docker-ce=%s", stdout)
	stdout, err = runCommandWithShell(dockerInst)
	if err != nil {
		return err
	}
	fmt.Println(stdout)

	fmt.Println("Docker", u.DockerVersion, "version is installed in this Host")

	return nil
}

//IsK8SComponentInstalled checks if said K8S version is already installed in the host
func (u *UbuntuOS) IsK8SComponentInstalled(component, defVersion string) (types.InstallState, error) {

	find := fmt.Sprintf("dpkg -l | grep %s | awk '{print $3}'", component)
	cmd := &Command{Cmd: exec.Command("sh", "-c", find)}
	cmd.ExecuteCommand()
	str := cmd.GetStdOutput()

	if strings.Contains(str, u.KubernetesVersion) {
		return types.AlreadySameVersionExist, nil
	}

	if err := u.addK8SRepositoryAndUpdate(); err != nil {
		return types.VersionNAInRepo, err
	}

	if str == "" {
		return types.NewInstallRequired, nil
	}

	isReqVerAvail, err := u.IsToolVerInRepo(component, u.KubernetesVersion)
	if err != nil {
		return types.VersionNAInRepo, err
	}

	var isDefVerAvail bool
	if u.KubernetesVersion != defVersion {
		isDefVerAvail, _ = u.IsToolVerInRepo(component, defVersion)
		if err != nil {
			return types.VersionNAInRepo, err
		}
	}

	if isReqVerAvail {
		return types.NewInstallRequired, nil
	}

	if isDefVerAvail {
		return types.DefVerInstallRequired, nil
	}

	return types.VersionNAInRepo, nil
}

func (u *UbuntuOS) addK8SRepositoryAndUpdate() error {
	//Get the distribution version
	cmd := &Command{Cmd: exec.Command("sh", "-c", "lsb_release -cs")}
	cmd.ExecuteCommand()
	distVersion := cmd.GetStdOutput()
	if distVersion == "" {
		return fmt.Errorf("ubuntu dist version not available")
	}
	fmt.Println("Ubuntu distribution version is", distVersion)
	distVersionForSuite := distVersion
	if distVersion == UbuntuBionic {
		// No bionic-specific version is available on apt.kubernetes.io.
		// Use xenial version instead.
		distVersionForSuite = UbuntuXenial
	}
	suite := fmt.Sprintf("kubernetes-%s", distVersionForSuite)
	fmt.Println("Deb suite to use:", suite)

	//Do an apt-get update
	stdout, err := runCommandWithShell("apt-get update")
	if err != nil {
		return err
	}
	fmt.Println(stdout)

	//curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
	//Get the GPG key
	curl := fmt.Sprintf("curl -s %s | apt-key add -", KubernetesGPGURL)
	cmd = &Command{Cmd: exec.Command("sh", "-c", curl)}
	cmd.ExecuteCommand()
	curlOutput := cmd.GetStdOutput()
	curlErr := cmd.GetStdErr()
	if curlOutput == "" || curlErr != "" {
		return fmt.Errorf("not able add the apt key due to error : %s", curlErr)
	}
	fmt.Println(curlOutput)

	//Add K8S repo to local apt-get source.list
	aptRepo := fmt.Sprintf("deb %s %s main", KubernetesDownloadURL, suite)
	updtRepo := fmt.Sprintf("echo \"%s\" > /etc/apt/sources.list.d/kubernetes.list", aptRepo)
	cmd = &Command{Cmd: exec.Command("sh", "-c", updtRepo)}
	cmd.ExecuteCommand()
	updtRepoErr := cmd.GetStdErr()
	if updtRepoErr != "" {
		return fmt.Errorf("not able add update repo due to error : %s", updtRepoErr)
	}

	//Do an apt-get update
	stdout, err = runCommandWithShell("apt-get update")
	if err != nil {
		return err
	}
	fmt.Println(stdout)
	return nil
}

//InstallK8S will install kubeadm, kudectl and kubelet for the cloud node
func (u *UbuntuOS) InstallK8S() error {
	k8sComponent := "kubeadm"
	fmt.Println("Installing", k8sComponent, u.KubernetesVersion, "version")

	//Get the exact version string from OS repo, so that it can search and install.
	chkKubeadmVer := fmt.Sprintf("apt-cache madison '%s' | grep %s | head -1 | awk '{$1=$1};1' | cut -d' ' -f 3", k8sComponent, u.KubernetesVersion)
	cmd := &Command{Cmd: exec.Command("sh", "-c", chkKubeadmVer)}
	cmd.ExecuteCommand()
	stdout := cmd.GetStdOutput()
	errout := cmd.GetStdErr()
	if errout != "" {
		return fmt.Errorf("%s", errout)
	}

	fmt.Println("Expected K8S('", k8sComponent, "') version to install is", stdout)

	//Install respective K8S components based on where it is being installed
	k8sInst := fmt.Sprintf("apt-get install -y --allow-change-held-packages --allow-downgrades kubeadm=%s kubelet=%s kubectl=%s", stdout, stdout, stdout)
	stdout, err := runCommandWithShell(k8sInst)
	if err != nil {
		return err
	}
	fmt.Println(stdout)

	fmt.Println(k8sComponent, "version", u.KubernetesVersion, "is installed in this Host")

	return nil
}

//StartK8Scluster will do "kubeadm init" and cluster will be started
func (u *UbuntuOS) StartK8Scluster() error {
	var install bool
	cmd := &Command{Cmd: exec.Command("sh", "-c", "kubeadm version")}
	cmd.ExecuteCommand()
	str := cmd.GetStdOutput()
	if str != "" {
		install = true
	} else {
		install = false
	}
	if install == true {
		k8sInit := fmt.Sprintf("swapoff -a && kubeadm init --image-repository  \"%s\" --pod-network-cidr=%s", u.K8SImageRepository, u.K8SPodNetworkCidr)
		stdout, err := runCommandWithShell(k8sInit)
		if err != nil {
			return err
		}
		fmt.Println(stdout)

		stdout, err = runCommandWithShell("mkdir -p $HOME/.kube && cp -r /etc/kubernetes/admin.conf $HOME/.kube/config &&  sudo chown $(id -u):$(id -g) $HOME/.kube/config")
		if err != nil {
			return err
		}
		fmt.Println(stdout)
	} else {
		return fmt.Errorf("kubeadm not installed in this host")
	}
	fmt.Println("Kubeadm init successfully executed")
	return nil
}
// // runCommandWithShell executes the given command with "sh -c".
// // It returns an error if the command outputs anything on the stderr.
// func runCommandWithShell(command string) (string, error) {
// 	cmd := &Command{Cmd: exec.Command("sh", "-c", command)}
// 	err := cmd.ExecuteCmdShowOutput()
// 	if err != nil {
// 		return "", err
// 	}
// 	errout := cmd.GetStdErr()
// 	if errout != "" {
// 		return "", fmt.Errorf("%s", errout)
// 	}
// 	return cmd.GetStdOutput(), nil
// }
