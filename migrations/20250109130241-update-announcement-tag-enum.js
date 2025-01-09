'use strict';

module.exports = {
  up: async (queryInterface, Sequelize) => {
    // Check if the type exists and if not, create it
    await queryInterface.sequelize.query(`
      DO $$
      BEGIN
        IF NOT EXISTS (SELECT 1 FROM pg_type WHERE typname = 'enum_announcements_tag') THEN
          CREATE TYPE "enum_announcements_tag" AS ENUM ('assignment', 'resource', 'general');
        END IF;
      END
      $$;
    `);

    // Add new values to the enum type, only if they don't already exist
    await queryInterface.sequelize.query(`
      DO $$
      BEGIN
        IF NOT EXISTS (SELECT 1 FROM pg_enum WHERE enumlabel = 'important' AND enumtypid = (SELECT oid FROM pg_type WHERE typname = 'enum_announcements_tag')) THEN
          ALTER TYPE "enum_announcements_tag" ADD VALUE 'important';
        END IF;
      END
      $$;
    `);

    await queryInterface.sequelize.query(`
      DO $$
      BEGIN
        IF NOT EXISTS (SELECT 1 FROM pg_enum WHERE enumlabel = 'reminder' AND enumtypid = (SELECT oid FROM pg_type WHERE typname = 'enum_announcements_tag')) THEN
          ALTER TYPE "enum_announcements_tag" ADD VALUE 'reminder';
        END IF;
      END
      $$;
    `);
  },

  down: async (queryInterface, Sequelize) => {
    // Note: Removing ENUM values is not straightforward. You may need to recreate the ENUM type.
    console.warn('Cannot safely remove ENUM values');
  },
};
