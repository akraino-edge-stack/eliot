package util

import (
	"fmt"
	"os/exec"
	//"github.com/spf13/elcli/cmd/common"
)

// EliotSetupAll function to reset the ELiot Topology
func EliotSetupAll() error {
	fmt.Println("Inside EliotSetupAll Function")
	

	strCdEliotScripts := fmt.Sprintf("cd ~/eliot/scripts/ && ls -l")
	strSetupAll := fmt.Sprintf("cd ~/eliot/scripts/ && bash setup.sh")
	cmd := &Command{Cmd: exec.Command("bash", "-c", strCdEliotScripts)}
	cmd.ExecuteCommand()

	stdout := cmd.GetStdOutput()
	errout := cmd.GetStdErr()
	if errout != "" {
		return fmt.Errorf("Error Output .. %s", errout)
	}
	
	fmt.Println("Output is ....   ", stdout)	
	   
	stdout, err := runCommandWithShell(strSetupAll)
	if err != nil {
	   return err
	}
	fmt.Println(stdout)
    return nil
}

//EliotSetupMaster Setup Method.
func EliotSetupMaster() error {
	fmt.Println("Inside EliotSetupMaster Function")

	strCdEliotScripts := fmt.Sprintf("cd ~/eliot/scripts/ && ls -l")
	
	cmd := &Command{Cmd: exec.Command("bash", "-c", strCdEliotScripts)}
	cmd.ExecuteCommand()

	stdout := cmd.GetStdOutput()
	errout := cmd.GetStdErr()
	if errout != "" {
		return fmt.Errorf("Error Output .. %s", errout)
	}	
	fmt.Println("Output is ....   ", stdout)	
	
	strSetupCommon := fmt.Sprintf("cd ~/eliot/scripts/ && bash common.sh")	   
	stdout, err := runCommandWithShell(strSetupCommon)
	if err != nil {
	   return err
	}
	fmt.Println(stdout)
	fmt.Println("Output is ....   ", stdout)	

	strSetupk8sMaster := fmt.Sprintf("cd ~/eliot/scripts/ && bash k8smaster.sh")	   
	stdout, err = runCommandWithShell(strSetupk8sMaster)
	if err != nil {
	   return err
	}
	fmt.Println(stdout)

    return nil
}