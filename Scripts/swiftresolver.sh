OUTPUT="${1}"
SOURCES_DIR="${PROJECT_DIR}"

if [ -z $OUTPUT ]; then
    OUTPUT="${PROJECT_DIR}/${PROJECT_NAME}/Sources/SwiftResolver/SwiftResolverGenerated.swift"
fi

#${PODS_ROOT}/Sourcery/bin/sourcery --templates "${PODS_ROOT}/SwiftResolver/Templates/inject.stencil" --sources "${SOURCES_DIR}/" --output "${OUTPUT}"
${PODS_ROOT}/Sourcery/bin/sourcery --templates "/Users/vinicius.rodrigues/Documents/Development/SwiftResolver/Templates/container-register.stencil" --sources "${SOURCES_DIR}/" --output "${OUTPUT}"
