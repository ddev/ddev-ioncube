<div align="center">

# ddev-ioncube - use IonCube Loaders in DDEV

![GitHub release (with filter)](https://img.shields.io/github/v/release/ddev/ddev-ioncube)
[![E2E Tests](https://github.com/ddev/ddev-ioncube/actions/workflows/cron_tests.yml/badge.svg?event=schedule)](https://github.com/ddev/ddev-ioncube/actions/workflows/tests.yml)
[![semantic-release: angular](https://img.shields.io/badge/semantic--release-angular-e10079?logo=semantic-release)](https://github.com/semantic-release/semantic-release)
![project is maintained](https://img.shields.io/maintenance/yes/2024.svg)

</div>

This repository provides [IonCube Loaders](https://www.ioncube.com/loaders.php) in DDEV Web container. 

## Features

✅ IonCube Loaders for all supported PHP versions  
✅ Multi-arch support (Will detect your system architecture and install the correct loader version)  
✅ Plays nice with your existing DDEV configuration  
✅ Works with other web container customizations  
✅ Set-and-forget workflow  

## Installation

For DDEV v1.23.5 or above run

```bash
ddev add-on get ddev/ddev-ioncube
```

For earlier versions of DDEV run

```bash
ddev get ddev/ddev-ioncube
```

Then restart the project

```bash
ddev restart
```

## Configuration

None. Addon works out-of-the-box.

**Developed and maintained by [Oblak Studio](https://github.com/oblakstudio)**
