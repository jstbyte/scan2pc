package main

import (
	"strings"

	"github.com/atotto/clipboard"
	"github.com/gofiber/fiber/v2"
)

func main() {
	app := fiber.New()

	// Handle Api Requests;
	app.Get("/", func(c *fiber.Ctx) error {

		result := c.Query("result")

		if strings.HasPrefix(result, "�") {
			result = result[4:32]
			println(result)
		}

		clipboard.WriteAll(result)
		return c.SendString(result)
	})
	app.Listen(":3000")
}

// "�B2781800011756620201207153928:DOC0404:DOC0051::E:"
