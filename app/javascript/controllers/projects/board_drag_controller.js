import { Controller } from '@hotwired/stimulus'

export default class extends Controller {
  dragStart(e) {
    e.dataTransfer.effectAllowed = 'move'
    e.dataTransfer.setData('text/html', e.currentTarget)
    e.currentTarget.classList.add('opacity-50')
  }

  dragEnd(e) {
    e.currentTarget.classList.remove('opacity-50')
  }

  dragOver(e) {
    e.preventDefault()
    e.dataTransfer.dropEffect = 'move'
    e.currentTarget.classList.add('bg-blue-100')
  }

  dragLeave(e) {
    e.currentTarget.classList.remove('bg-blue-100')
  }

  drop(e) {
    e.preventDefault()
    e.currentTarget.classList.remove('bg-blue-100')

    const draggedCard = document.querySelector('.opacity-50')
    if (!draggedCard) return

    const workItemId = draggedCard.dataset.workItemId
    const toStageId = e.currentTarget.dataset.stageId
    const fromStageId = draggedCard.closest('[data-stage-id]').dataset.stageId

    if (!workItemId || !toStageId || !fromStageId) {
      console.error('Missing values', { workItemId, toStageId, fromStageId })
      return
    }

    const form = document.querySelector(`#move-stage-form-${toStageId}`)
    if (!form) {
      console.error(`Form not found: #move-stage-form-${toStageId}`)
      return
    }

    form.action = form.action.replace(/\/0\/move_stage/, `/${workItemId}/move_stage`)

    const fromStageField = form.querySelector('input[name="from_stage_id"]')
    fromStageField.value = fromStageId

    form.requestSubmit()
  }
}
