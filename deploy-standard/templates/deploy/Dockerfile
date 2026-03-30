# Syntax baseline for generated deploy files.
# Replace every placeholder with values derived from repository analysis.

FROM {{BASE_IMAGE}}

{{SYSTEM_PACKAGES_BLOCK}}

WORKDIR /app

{{DEPENDENCY_COPY_BLOCK}}

{{DEPENDENCY_INSTALL_BLOCK}}

COPY . .

{{BUILD_BLOCK}}

ENV {{PORT_ENV_NAME}}={{PORT_VALUE}}

{{EXPOSE_BLOCK}}

CMD {{CMD_JSON}}
