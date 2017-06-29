#${PODS_ROOT}
OUTPUT="${1}"
SOURCES_DIR="../../${PROJECT_DIR}"

../Sourcery/bin/sourcery --templates "./Templates/container-register.stencil" --sources "${SOURCES_DIR}/" --output "${OUTPUT}"

