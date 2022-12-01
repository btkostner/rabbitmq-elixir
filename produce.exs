Mix.install([
  {:amqp, "~> 3.2"}
], force: true)

{:ok, conn} = AMQP.Connection.open()
{:ok, chan} = AMQP.Channel.open(conn)

for number <- 1..100 do
  for route_key <- 0..3 do
    :ok = AMQP.Basic.publish(chan, "test_super_stream", to_string(route_key), to_string(number))
  end

  :ok = AMQP.Basic.publish(chan, "test_stream", "", to_string(number))
end
