package algorithm

// GetTargetIndex Unoptimized binary search
func GetTargetIndex(orderedList []int, targetValue int) int {

	var scopeStart = 0
	var scopeEnd = len(orderedList) - 1
	var selectedIndex = getMiddle(scopeStart, scopeEnd)
	var selectedValue = orderedList[selectedIndex]

	for {
		if selectedValue == targetValue {
			return selectedIndex
		}

		if selectedValue > targetValue {
			scopeEnd = selectedIndex
		}

		if selectedValue < targetValue {
			if orderedList[selectedIndex+1] == targetValue {
				return selectedIndex + 1
			}
			scopeStart = selectedIndex
		}

		if scopeEnd == scopeStart {
			return -1
		}

		selectedIndex = getMiddle(scopeStart, scopeEnd)
		selectedValue = orderedList[selectedIndex]
	}

}

func getMiddle(startPosition, endPosition int) int {
	// This value needs to be rounded to bottom.
	return (endPosition + startPosition) / 2
}
