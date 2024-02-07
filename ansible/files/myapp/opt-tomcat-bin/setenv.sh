# Add setup token
CATALINA_OPTS="$CATALINA_OPTS -DMYAPP_SETUP_TOKEN=CheckMeOut123"

# Add logging configuration
CATALINA_OPTS="$CATALINA_OPTS -Dorg.ops4j.pax.logging.property.file=$CATALINA_BASE/conf/log4j2.myapp.xml"

export CATALINA_OPTS