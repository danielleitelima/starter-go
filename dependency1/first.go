package dependency1

import "fmt"

var PublicVariable = "This is a public variable."

var privateVariable = "SECRET"

func PublicFunction() {
	// This is a public function.
	fmt.Println("This is a public function.")
	privateFunction()
}

func privateFunction() {
	fmt.Println("This is the content of the private variable:", privateVariable)
}
