import { Application } from "@hotwired/stimulus"
import SortableController from "./controllers/sortable_controller"; // Adjust path if necessary


const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application
application.register("sortable", SortableController);

export { application }


