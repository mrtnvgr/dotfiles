{ ... }: {
  imports = [
    ./secrets/torrserver.nix
  ];

  modules.generic.services.sshd = {
    enable = true;
    keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCkZjolhKpAeBEd9BHXbg/AVPjj7EYJv07nbtoyWRZJq4nYpWA7GX21fgH4g1v32ZjzqUtVXjBXZg6kYap1P2AxePQCQBYPksUVoS9lVVPSspyhx9Tk/9otyQh7Dye5jgfSRAo54Q1sRsEptN9351ti8smKt0u2eOCcGVStKSK3ZjB47issc4i2nOdInvhdA7ZZJvMAxepS+a3KVc2edkjBoSyuJ88IZaNlZcL5iE4UVeZ9C+QP0B6oBYQxIQZXq9ywCvVgZ8O0sU6aJxDLjuB3/7xAPpxHOW3hNYyoAgor0bpCiGd4nHX1wlJv//uW+yTWIyX+5Qimj/td4iORz/VHK7VVx81AJDapJqTPwOsXeg/x228/jXZy9I1b+ASH3qj6F4yo/e/rBXWLuxcdW4e+LYNzWAOzzztPyV78omeNmE2MgPwsvddmQgO5J45KNZjKejqCwUeXFjZGg98aFLq0Qnx6JM3hOyNFZWrWvbMchNqCO0YiQFbc4aY3ecfQfxU= u0_a368@localhost" ];
  };

  modules.server = {
    enable = true;

    services.torrserver.enable = true;

    services.twitch-recorder = {
      enable = true;
      channels = [ "msx2plus" ];
    };
  };

  system.stateVersion = "24.05";
}
