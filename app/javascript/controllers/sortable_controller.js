import { Controller } from "@hotwired/stimulus";
import Sortable from "sortablejs";

export default class extends Controller {
  static values = { url: String }

  connect() {
    console.log("Sortable controller connected!");
    this.initSortable();
  }

  initSortable() {
    Sortable.create(this.element, {
      animation: 150, // Smooth animation
      onEnd: this.updateOrder.bind(this), // Trigger on drag end
    });
  }

  updateOrder(event) {
    const items = Array.from(this.element.children); // List all sortable items
    const sortedData = items.map((item, index) => ({
      id: item.dataset.id, // Get the item's ID
      order: index + 1,    // Assign new order
    }));

    console.log("Sorted Data:", sortedData); // Debug: Check data before sending

    fetch(this.urlValue, {
      method: "PATCH",
      headers: {
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector('meta[name="csrf-token"]').content,
      },
      body: JSON.stringify({ assessment_items: sortedData }),
    })
      .then(response => {
        if (response.ok) {
          console.log("Order updated successfully!");
        } else {
          console.error("Failed to update order.");
        }
      })
      .catch(error => console.error("Error updating order:", error));
  }
}
