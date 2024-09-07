// app/javascript/controllers/save-stage_controller.js

// Define your Stimulus controller

export default class extends Controller {
  connect() {
    console.log("Stimulus controller connected!");
  }

  saveStage(event) {
    const stage = event.target.value;
    const blossomId = event.target.id.split("_")[1]; // Extract blossom ID from radio button ID

    console.log(`Saving stage ${stage} for blossom ID ${blossomId}`);

    fetch('/save_blossom_stage', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
      },
      body: JSON.stringify({ blossom_id: blossomId, stage: stage }),
    }).then(response => {
      if (response.ok) {
        console.log('Stage saved successfully.');
      } else {
        console.error('Failed to save stage.');
      }
    }).catch(error => {
      console.error('Error saving stage:', error);
    });
  }
}
