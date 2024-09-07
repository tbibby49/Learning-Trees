document.addEventListener('turbo:load', () => {
  const gridContainer = document.getElementById('grid-container');
  const lineCanvas = document.getElementById('lineCanvas');
  if (!lineCanvas) {
    return; // Exit if the lineCanvas element is not present on the page
  }
  const lineCtx = lineCanvas.getContext('2d');

  // Create 11x7 grid
  for (let i = 0; i < 10; i++) {
      for (let j = 0; j < 10; j++) {
          const cell = document.createElement('div');
          cell.classList.add('grid-cell');
          cell.setAttribute('id', `cell-${i}-${j}`);
          cell.setAttribute('data-row', i);
          cell.setAttribute('data-column', j);
          cell.addEventListener('dragover', allowDrop);
          cell.addEventListener('drop', drop);
          gridContainer.appendChild(cell);
      }
  }

  // Set up draggable items and place them in the correct cells
  const blossoms = document.querySelectorAll('.blossom');
  blossoms.forEach(blossom => {
      const row = blossom.getAttribute('data-row');
      const column = blossom.getAttribute('data-column');
      const targetCell = document.querySelector(`#cell-${row}-${column}`);
      if (targetCell) {
          targetCell.appendChild(blossom);
      }
      blossom.addEventListener('dragstart', drag);
  });

  // Draw lines after page load
  drawLinesExcept(null, null);

  function allowDrop(event) {
      event.preventDefault();
  }

  function drag(event) {
      console.log('Dragging blossom:', event.target.id);
      event.dataTransfer.setData('text', event.target.id);
  }

  function drop(event) {
      event.preventDefault();
      const data = event.dataTransfer.getData('text');
      const movedBlossom = document.getElementById(data);
      console.log('Blossom:', movedBlossom);

      if (!movedBlossom) {
          console.error('Blossom not found');
          return;
      }

      const targetCell = event.target.classList.contains('grid-cell') ? event.target : event.target.closest('.grid-cell');
      if (!targetCell) {
          console.error('Target cell not found');
          return;
      }

      const sourceCell = movedBlossom.parentElement;
      const sourceRow = movedBlossom.getAttribute('data-row');
      const sourceColumn = movedBlossom.getAttribute('data-column');
      const targetRow = targetCell.getAttribute('data-row');
      const targetColumn = targetCell.getAttribute('data-column');

      // Only allow dropping into empty cells
      if (!targetCell.hasChildNodes()) {
          targetCell.appendChild(movedBlossom);
          movedBlossom.setAttribute('data-row', targetRow);
          movedBlossom.setAttribute('data-column', targetColumn);

          savePositionsToServer();
          drawLinesExcept(sourceRow, sourceColumn);
      } else if (event.target.classList.contains('blossom')) {
          const targetBlossom = event.target;
          const targetBlossomRow = targetBlossom.getAttribute('data-row');
          const targetBlossomColumn = targetBlossom.getAttribute('data-column');

          // Swap positions of the blossoms
          sourceCell.appendChild(targetBlossom);
          targetCell.appendChild(movedBlossom);

          // Update data attributes
          movedBlossom.setAttribute('data-row', targetBlossomRow);
          movedBlossom.setAttribute('data-column', targetBlossomColumn);
          targetBlossom.setAttribute('data-row', sourceRow);
          targetBlossom.setAttribute('data-column', sourceColumn);

          savePositionsToServer();
          drawLinesExcept(sourceRow, sourceColumn);
      }
  }

  function savePositionsToServer() {
      console.log('Saving positions to server');
      const positions = {};
      const gridCells = document.querySelectorAll('.grid-cell');
      gridCells.forEach(cell => {
          const blossom = cell.querySelector('.blossom');
          if (blossom) {
              const row = cell.getAttribute('data-row');
              const column = cell.getAttribute('data-column');
              positions[blossom.id.replace('blossom_', '')] = { row: parseInt(row, 10), column: parseInt(column, 10) };
          }
      });

      const treeId = document.querySelector('meta[name="tree-id"]').getAttribute('content');
      const branchId = document.querySelector('meta[name="branch-id"]').getAttribute('content');

      fetch(`/trees/${treeId}/branches/${branchId}/blossoms/update_positions`, {
          method: 'PATCH',
          headers: {
              'Content-Type': 'application/json',
              'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
          },
          body: JSON.stringify({ positions: positions })
      }).then(response => {
          if (response.ok) {
              console.log('Positions updated successfully');
          } else {
              console.error('Failed to update positions');
          }
      }).catch(error => {
          console.error('Error saving positions:', error);
      });
  }

  function drawLinesExcept(exceptRow, exceptColumn) {
      lineCtx.clearRect(0, 0, lineCanvas.width, lineCanvas.height);
      lineCtx.strokeStyle = 'black';
      lineCtx.lineWidth = 8;

      blossoms.forEach(blossom => {
          const startCell = blossom.parentElement;
          if (!startCell) {
              console.error('Blossom does not have a parent cell:', blossom);
              return;
          }

          const startRow = parseInt(blossom.getAttribute('data-row'));
          const startColumn = parseInt(blossom.getAttribute('data-column'));

          if (startRow === parseInt(exceptRow) && startColumn === parseInt(exceptColumn)) {
              return;
          }

          const startX = startCell.offsetLeft + startCell.offsetWidth / 2;
          const startY = startCell.offsetTop + startCell.offsetHeight / 2;

          let closestEndX = null;
          let closestEndY = null;
          let closestDistance = Infinity;

          blossoms.forEach(otherBlossom => {
              if (blossom === otherBlossom) return;

              const otherRow = parseInt(otherBlossom.getAttribute('data-row'));
              const otherColumn = parseInt(otherBlossom.getAttribute('data-column'));

              if (otherColumn >= startColumn) return;

              const otherCell = otherBlossom.parentElement;
              if (!otherCell) return;

              const otherX = otherCell.offsetLeft + otherCell.offsetWidth / 2;
              const otherY = otherCell.offsetTop + otherCell.offsetHeight / 2;

              const distance = Math.sqrt(Math.pow(otherX - startX, 2) + Math.pow(otherY - startY, 2));

              if (distance < closestDistance) {
                  closestDistance = distance;
                  closestEndX = otherX;
                  closestEndY = otherY;
              }
          });

          if (closestEndX !== null && closestEndY !== null) {
              lineCtx.beginPath();
              lineCtx.moveTo(startX, startY);
              lineCtx.lineTo(closestEndX, closestEndY);
              lineCtx.stroke();
          }
      });

      console.log('Lines drawn except for moved blossom.');
  }
});
