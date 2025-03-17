import Sortable from 'stimulus-sortable'

export default class extends Sortable {
  connect() {
    super.connect()
    this.sortable.option('handle', '.drag-handle');

    this.sortable.option('onStart', this.startDragging.bind(this));
    this.sortable.option('onEnd', this.stopDragging.bind(this));
  }

  startDragging(evt) {
    const handle = evt.item.querySelector('.drag-handle');
    if (handle) {
      handle.classList.add("cursor-grabbing");
      handle.classList.remove("cursor-grab");
    }
  }

  stopDragging(evt) {
    const handle = evt.item.querySelector('.drag-handle');
    if (handle) {
      handle.classList.add("cursor-grab");
      handle.classList.remove("cursor-grabbing");
    }
  }
}