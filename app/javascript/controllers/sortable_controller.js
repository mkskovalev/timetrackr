import Sortable from 'stimulus-sortable'

export default class extends Sortable {
  connect() {
    super.connect()
    this.sortable.option('handle', '.drag-handle');
  }
}