MAX_POOL_SIZE = Rails.application.secrets.redis_max_pool_size || 15
# redis_url = 'redis://localhost:6379/0'
redis_url = 'redis://redis:6379/0'

$redis = ConnectionPool::Wrapper.new(size: MAX_POOL_SIZE, timeout: 3) {
  Redis.new(url: redis_url)
}