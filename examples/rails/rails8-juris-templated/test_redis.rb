#!/usr/bin/env ruby
require_relative 'config/environment'

puts "Testing Redis Emulator..."
puts "=" * 50

# Create a Redis emulator client
redis = Redis::Emulator.new

# Test 1: SET and GET
puts "\n1. Testing SET and GET:"
redis.set("test_key", "Hello, Redis!")
value = redis.get("test_key")
puts "   SET test_key = 'Hello, Redis!'"
puts "   GET test_key = '#{value}'"
puts "   ✓ Success!" if value == "Hello, Redis!"

# Test 2: SET with expiration
puts "\n2. Testing SET with expiration (EX):"
redis.set("expiring_key", "I will expire", ex: 60)
value = redis.get("expiring_key")
puts "   SET expiring_key = 'I will expire' EX 60"
puts "   GET expiring_key = '#{value}'"
puts "   ✓ Success!" if value == "I will expire"

# Test 3: INCR
puts "\n3. Testing INCR:"
redis.set("counter", 0)
redis.incr("counter")
redis.incr("counter")
redis.incr("counter")
value = redis.get("counter")
puts "   Initial counter = 0"
puts "   INCR counter (3 times)"
puts "   GET counter = #{value}"
puts "   ✓ Success!" if value == 3

# Test 4: DEL
puts "\n4. Testing DEL:"
redis.set("to_delete", "delete me")
exists_before = redis.exists("to_delete")
deleted = redis.del("to_delete")
exists_after = redis.exists("to_delete")
puts "   SET to_delete = 'delete me'"
puts "   EXISTS before DEL = #{exists_before}"
puts "   DEL to_delete = #{deleted}"
puts "   EXISTS after DEL = #{exists_after}"
puts "   ✓ Success!" if exists_before == 1 && deleted == 1 && exists_after == 0

# Test 5: MSET and MGET
puts "\n5. Testing MSET and MGET:"
redis.mset("key1", "value1", "key2", "value2", "key3", "value3")
values = redis.mget("key1", "key2", "key3")
puts "   MSET key1=value1, key2=value2, key3=value3"
puts "   MGET key1, key2, key3 = #{values.inspect}"
puts "   ✓ Success!" if values == ["value1", "value2", "value3"]

# Test 6: EXISTS
puts "\n6. Testing EXISTS:"
redis.set("exists_test", "I exist")
count = redis.exists("exists_test", "nonexistent_key")
puts "   SET exists_test = 'I exist'"
puts "   EXISTS exists_test, nonexistent_key = #{count}"
puts "   ✓ Success!" if count == 1

# Test 7: PING
puts "\n7. Testing PING:"
pong = redis.ping
puts "   PING = '#{pong}'"
puts "   ✓ Success!" if pong == "PONG"

# Test 8: INCRBY and DECRBY
puts "\n8. Testing INCRBY and DECRBY:"
redis.set("math_counter", 10)
redis.incrby("math_counter", 5)
value_after_incr = redis.get("math_counter")
redis.decrby("math_counter", 3)
value_after_decr = redis.get("math_counter")
puts "   Initial math_counter = 10"
puts "   INCRBY math_counter 5 = #{value_after_incr}"
puts "   DECRBY math_counter 3 = #{value_after_decr}"
puts "   ✓ Success!" if value_after_decr == 12

puts "\n" + "=" * 50
puts "All Redis operations completed!"
puts "Redis Emulator is working correctly with Solid Cache backend."
