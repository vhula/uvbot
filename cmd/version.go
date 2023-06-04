package cmd

import (
	"fmt"

	"github.com/spf13/cobra"
)

var appVersion = "Version"

var versionCmd = &cobra.Command{
	Use:   "version",
	Short: "Prints the current version of the UV Bot CLI",
	Run: func(cmd *cobra.Command, args []string) {
		fmt.Println(appVersion)
	},
}

func init() {
	rootCmd.AddCommand(versionCmd)
}
