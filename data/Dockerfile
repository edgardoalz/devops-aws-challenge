FROM flyway/flyway:7

USER flyway

COPY --chown=flyway:flyway ./migrations /flyway/sql

COPY --chown=flyway:flyway ./bin/migrate ./migrate

RUN chmod u+x migrate

ENTRYPOINT ["migrate"]
CMD [""]