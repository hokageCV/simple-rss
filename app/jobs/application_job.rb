class ApplicationJob < ActiveJob::Base
  # Automatically retry jobs that encountered a deadlock
  # retry_on ActiveRecord::Deadlocked

  # Most jobs are safe to ignore if the underlying records are no longer available
  # discard_on ActiveJob::DeserializationError

  around_perform :with_semantic_logging

  private

  def with_semantic_logging(&block)
    SemanticLogger.tagged(
      job_class:  self.class.name,
      job_id:     job_id,
      queue_name: queue_name
    ) do
      logger.info "Job started"
      block.call
      logger.info "Job completed"
    end
  rescue => e
    logger.error "Job failed", exception: e
    raise
  end
end
