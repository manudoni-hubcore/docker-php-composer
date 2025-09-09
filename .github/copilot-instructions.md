# Copilot Instructions for docker-php-composer

## Project Overview
This repository provides a Docker image for running Composer (PHP dependency manager) in isolated, reproducible environments—primarily for use with WSL or any Docker-compatible system. The image is based on Laravel Sail with Composer preinstalled, and is designed to simplify PHP dependency management without requiring Composer to be installed on the host system.

## Key Architectural Decisions
- **Base Image:** Uses `laravelsail/php${PHP_VERSION}-composer:latest` for compatibility with Laravel and modern PHP workflows.
- **User Management:** Creates a non-root `docker` user (configurable via build args) to avoid permission issues when mounting volumes.
- **Global Tools:** Installs `laravel/installer` and `cpx` globally for convenience in Laravel and PHP projects.
- **Volumes:**
  - `composer_data:/home/docker/.composer` for persistent Composer cache/config.
  - `$(pwd):/var/www/html` for project source code, enabling seamless local development.

## Developer Workflows
- **Build Image:**
  - Standard: `docker build -t manudonihubcoreai/composer:latest .`
  - Custom PHP/user: `docker build --build-arg PHP_VERSION=81 --build-arg USER_ID=$(id -u) --build-arg USER_GROUP=$(id -g) -t manudonihubcoreai/composer:81 .`
- **Run Composer Commands:**
  - Example: `docker run -it --rm -u "$(id -u):$(id -g)" -v composer_data:/home/docker/.composer -v "$(pwd):/var/www/html" -w /var/www/html manudonihubcoreai/composer:latest composer install`
- **Recommended Aliases:**
  - For frequent use, add to shell config:
    ```bash
    alias composer='docker run -it --rm -u "$(id -u):$(id -g)" -v composer_data:/home/docker/.composer -v "$(pwd):/var/www/html" -w /var/www/html manudonihubcoreai/composer:latest composer'
    ```

## Project-Specific Conventions
- Always run as the `docker` user to avoid permission issues on mounted volumes.
- Use the provided volume mounts for Composer cache and project files.
- All Composer commands should be run inside the container, not on the host.
- The image is intended for development, not production.

## Integration Points
- **External:**
  - Relies on Docker and the Laravel Sail PHP images.
  - Integrates with any PHP project via volume mounting.
- **Global Composer Packages:**
  - `laravel/installer` and `cpx` are available globally in the container.

## Example Commands
- Install dependencies: `composer install`
- Require a package: `composer require vendor/package`
- Show global packages: `composer global show -D`

## Reference Files
- `Dockerfile`: Defines the image build process, user setup, and global Composer packages.
- `README.md`: Documents usage patterns, build/run instructions, and recommended aliases.

---

**For AI agents:**
- Follow the volume and user conventions strictly to avoid permission issues.
- Reference the `README.md` for up-to-date usage patterns and command examples.
- If adding new global Composer packages, update both the `Dockerfile` and documentation.
