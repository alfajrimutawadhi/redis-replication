# Redis Replication
In this project I'm trying to make a mini replication of [redis](https://redis.io) using the Ruby programming language. This project is not perfect yet. Because it can only handle a few command requests, and it can't store the result data permanently yet.   

Some of the command requests that can be processed are :
- PING
    ```syntax
    PING [message]
    ```
- ECHO
    ```syntax
    ECHO message
    ```
- SET
    ```syntax
    SET key value [NX | XX] [EX seconds | PX milliseconds]
    ```
- GET
    ```syntax
    GET key
    ```
- DEL
    ```syntax
    DEL key [key ...]
    ```

For more detailed information about command requests, you can visit in [Here](https://redis.io/commands/).

## How to run
The requirement is that you must have installed [Ruby 3.0.0](https://www.ruby-lang.org/en/news/2020/12/25/ruby-3-0-0-released/) or higher.

Steps :
- Clone this repository
    ```bash
    git clone https://github.com/alfajrimutawadhi/redis-replication.git redis-replication && cd redis-replication
    ```
- Run command
    ```bash
    exec ruby server.rb
    ```
- You can operate your redis-client now