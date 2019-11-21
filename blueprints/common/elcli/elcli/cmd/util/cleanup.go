package util


import (
	"fmt"
	"os/exec"
)
// EliotClean function to reset the ELiot Topology
func EliotClean() error {
	fmt.Println("Inside EliotClean Function")
	
	cdEliotScripts := fmt.Sprintf("cd ~/eliot/scripts/ && ls -l")
	shCleanEliotTopology := fmt.Sprintf("cd ~/eliot/scripts/ && bash kubernetes_cleanup.sh")
	cmd := &Command{Cmd: exec.Command("bash", "-c", cdEliotScripts)}
	cmd.ExecuteCommand()

	stdout := cmd.GetStdOutput()
	errout := cmd.GetStdErr()
	
	if errout != "" {
	 return fmt.Errorf("Error Output .. %s", errout)
	}
	fmt.Println("Output is ....   ", stdout)	
	
	stdout, err := runCommandWithShell(shCleanEliotTopology)
	if err != nil {
		return err
	}
	fmt.Println(stdout)

	return nil
}

// EliotReset function to Reset the ELIOT Cluster.
func EliotReset() error {
	fmt.Println("Inside EliotReset Function")
	
	cdEliotScripts := fmt.Sprintf("cd ~/eliot/scripts/ && ls -l")
	shResetEliotTopology := fmt.Sprintf("cd ~/eliot/scripts/ && bash kubernetes_reset.sh")
	cmd := &Command{Cmd: exec.Command("sh", "-c", cdEliotScripts)}
	cmd.ExecuteCommand()

	stdout := cmd.GetStdOutput()
	errout := cmd.GetStdErr()

	if errout != "" {
	 return fmt.Errorf("Error Output .. %s", errout)
	}
	fmt.Println("Output is ....  \n ", stdout)	
	return nil

	stdout, err := runCommandWithShell(shResetEliotTopology)
	if err != nil {
		return err
	}
	fmt.Println(stdout)

	return nil
}