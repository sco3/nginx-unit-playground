package main

import (
	"encoding/json"
	"net/http"
	"unit.nginx.org/go"
)

// Item matches your Pydantic model
type Item struct {
	Name        string  `json:"name"`
	Price       float64 `json:"price"`
	Quantity    int     `json:"quantity"`
	Description *string `json:"description,omitempty"`
}

func createItemHandler(w http.ResponseWriter, r *http.Request) {
	if r.Method != http.MethodPost {
		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		return
	}

	var item Item
	if err := json.NewDecoder(r.Body).Decode(&item); err != nil {
		http.Error(w, err.Error(), http.StatusBadRequest)
		return
	}

	// Calculate total
	total := item.Price * float64(item.Quantity)

	// Create response
	response := map[string]interface{}{
		"message": "Item created successfully",
		"item":    item,
		"total":   total,
	}

	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(response)
}

func rootHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")
	json.NewEncoder(w).Encode(map[string]string{"message": "Go: welcome to the API"})
}

func main() {
	// Routing
	http.HandleFunc("/items", createItemHandler)
	http.HandleFunc("/", rootHandler)

	// unit.ListenAndServe is the drop-in replacement for http.ListenAndServe
	if err := unit.ListenAndServe(":8333", nil); err != nil {
		panic(err)
	}
}
