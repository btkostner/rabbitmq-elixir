# RabbitMQ + Elixir

This repository demos rabbitmq super streams with Elixir and broadway.

## Setup

This uses docker compose to setup rabbitmq. The `definitions.json` are preloaded with all of the queues and extensions we need. You can access the rabbitmq web interface on [`http://localhost:15672/`](http://localhost:15672/) with `guest:guest` as the login.

To start the consumers, run `elixir --no-halt consume.exs`

To add messages to the queues, run `elixir produce.exs`
