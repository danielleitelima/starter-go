package main

import (
	"fmt"
	// It is possible to access a dependency1 using an alias.
	customDependencyName "github.com/danielleitelima/starter-go-foundation/dependency1"

	"slices"
)

// The main function is the entry point of the program.
func main() {
	// This is how you print a string in GO.
	fmt.Println("Hi, I'm a Go program!")

	// You can also not break the line automatically.
	fmt.Print("\n---------\n")

	// Use different names for variables in relation to types, changing the case of the first letter is not enough.
	var mString = "My string"

	// You can use the %s in the Printf formatting function to replace the value of the variable, but you need to break the line.
	fmt.Printf("My string: %s\n", mString)

	// The type can be inferred by the value of the variable.
	// By default, the int type is int64.
	var mInt int = 10

	fmt.Println("My integer:", mInt)

	// You can also use the := operator to declare and assign a value to a variable.
	// The type of the variable is inferred by the value.
	mFloat := 10.5

	fmt.Println("My float:", mFloat)

	// This is how you invoke a function.
	myFunction(mString, mFloat, 1, 2, 3, 4, 5)

	// The name of the package can be used as a variable to access it's public content.
	customDependencyName.PublicFunction()

	// The private variable is not accessible outside the package.
	// dependency1.privateVariable()

	AnotherFunction()
}

// You can pass	as many parameters as you want to a function, until you use a variable parameter.
// The variable parameter must be the last parameter of the function.
func myFunction(
	firstParameter string,
	secondParameter float64,
	// If you break the line, you need to add a comma at the end of the last parameter of the function.
	variableParameter ...int,
) {
	fmt.Println("Executing a function.")
	// You can also use the "defer" keyword to execute a function at the end of the current function.
	defer fmt.Println("The function has finished.")

	// A variable parameter is accessed as a slice of integers.
	var finalParameters = append(variableParameter, 123123)

	// You need to update the slice with the new values after the append function.
	finalParameters = append(finalParameters, int(secondParameter))

	// You can also use the len function to get the length of the string.
	finalParameters = append(finalParameters, len(firstParameter))

	// The "slices" standard library has utility functions to work with of course ... slices.
	// There is no need to update the variable because the function does not return a new slice.
	slices.Reverse(finalParameters)

	// It is possible to use the range keyword to iterate over the values of the slice.
	for index, value := range finalParameters {

		if index == 0 {
			// You can use "%v" to print the value of the variable for integers, but it also works with strings.
			fmt.Printf("The first parameter has: %v characters.\n", value)
			continue
		}

		if index == 1 {
			fmt.Printf("My second parameter's integer value converting from float64 is: %v\n", value)
			continue
		}

		// You can also use the fmt.Println function to print the values this way.
		fmt.Println("This is the index:", index, "and this is the value:", value)
	}
}
