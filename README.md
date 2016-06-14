# Consul Bridge

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'consul_bridge'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install consul_bridge

## Usage

Master nodes:
`docker run -d --net=host outstand/consul_bridge start -b <heartbeat bucket> -n <consul container name> -a`

Client nodes:
`docker run -d --net=host outstand/consul_bridge start -b <heartbeat bucket> -n <consul container name>`

## Development

- `docker volume create --name fog`
- `./build_dev.sh`
- `docker run -it --rm --net=host -v $(pwd):/consul_bridge -v fog:/fog -e FOG_LOCAL=true outstand/consul_bridge:dev start -b bucket -n backup`

To release a new version:
- Update the version number in `version.rb` and `Dockerfile.release` and commit the result.
- `./build_dev.sh`
- `docker run -it --rm -v ~/.gitconfig:/root/.gitconfig -v ~/.gitconfig.user:/root/.gitconfig.user -v ~/.ssh/id_rsa:/root/.ssh/id_rsa -v ~/.gem:/root/.gem outstand/consul_bridge:dev rake release`
- `docker build -t outstand/consul_bridge:VERSION -f Dockerfile.release .`
- `docker push outstand/consul_bridge:VERSION`

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/outstand/consul_bridge.

