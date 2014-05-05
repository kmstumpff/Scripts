BEGIN
   FOR cur_rec IN (SELECT object_name, object_type
                     FROM user_objects
                    WHERE object_type IN
                             ('VIEW',
                              'PACKAGE',
                              'PROCEDURE',
                              'FUNCTION',
                              'SEQUENCE',
                              'INDEX',
                              'TYPE',
                              'TABLE'
                             ))
   LOOP
      BEGIN
         CASE WHEN cur_rec.object_type = 'TABLE'
         THEN
            EXECUTE IMMEDIATE    'DROP '
                              || cur_rec.object_type
                              || ' "'
                              || cur_rec.object_name
                              || '" CASCADE CONSTRAINTS';
         WHEN cur_rec.object_type = 'TYPE'
         THEN
            EXECUTE IMMEDIATE    'DROP '
                              || cur_rec.object_type
                              || ' "'
                              || cur_rec.object_name
                              || '" FORCE';
         ELSE
            EXECUTE IMMEDIATE    'DROP '
                              || cur_rec.object_type
                              || ' "'
                              || cur_rec.object_name
                              || '"';
         END CASE;
      EXCEPTION
         WHEN OTHERS
         THEN
            DBMS_OUTPUT.put_line (   'FAILED: DROP '
                                  || cur_rec.object_type
                                  || ' "'
                                  || cur_rec.object_name
                                  || '"'
                                 );
      END;
   END LOOP;
END;
/