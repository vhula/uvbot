package cmd

import (
	"fmt"
	"log"
	"os"
	"time"

	"github.com/spf13/cobra"

	telebot "gopkg.in/telebot.v3"
)

var (
	TeleToken = os.Getenv("TELE_TOKEN")
)

var startCmd = &cobra.Command{
	Use:   "start",
	Short: "Starts UV Bot binary that serves as the backend for the Telegram Bot",
	Run: func(cmd *cobra.Command, args []string) {
		kbotSettings := telebot.Settings{
			URL:    "",
			Token:  TeleToken,
			Poller: &telebot.LongPoller{Timeout: 10 * time.Second},
		}
		kbot, err := telebot.NewBot(kbotSettings)
		if err != nil {
			log.Fatalf("Please check the TELE_TOKEN env variable. %s", err)
			return
		}
		kbot.Handle(telebot.OnText, func(ctx telebot.Context) error {
			log.Print(ctx.Message().Payload, ctx.Text())
			payload := ctx.Message().Payload
			switch payload {
			case "hello":
				err = ctx.Send(fmt.Sprintf("Hello. I'm UV Bot %s!", appVersion))
			case "bye":
				err = ctx.Send(fmt.Sprintf("Goodbye. I'm UV Bot %s!", appVersion))
			}
			return err
		})
		kbot.Start()
	},
}

func init() {
	rootCmd.AddCommand(startCmd)
}
