## 1.5.0 2023-04-26 <dave at tiredofit dot ca>

   ### Added
      - Add support for _FILE environment variables


## 1.4.1 2023-01-26 <dave at tiredofit dot ca>

   ### Changed
      - Fix for extra arguments not being passed on mount process


## 1.4.0 2023-01-25 <dave at tiredofit dot ca>

   ### Added
      - Add CACHE_SIZE environment variable
      - Make log file names more consistent
      - Create recovery key backup in CONFIG_PATH on filesystem creation
      - Force dismounts on container shutdown

   ### Changed
      - Lots of bug fixes, annoyances, and quirks


## 1.3.0 2023-01-25 <dave at tiredofit dot ca>

   ### Added
      - Add unmount command on container stop to target any `fuse.s3ql` filesystems

   ### Changed
      - Change `S3QL_ARGS` to `MOUNT_ARGS`


## 1.2.0 2023-01-24 <dave at tiredofit dot ca>

   ### Added
      - Pin some python modules to have specific version constraints


## 1.1.0 2023-01-24 <dave at tiredofit dot ca>

   ### Added
      - Add `fsck-now` script for file system checking
      - Add force-dismount script for stuck filesystems that have failed

   ### Changed
      - Properly write to the LOG_PATH


## 1.0.0 2023-01-20 <dave at tiredofit dot ca>

   ### Added
      - Auto create S3QL filesystem if not exist
      - FSCK upon container startup
      - Adjustable compression functionality
      - Adjustable LOG_TYPE
      - Ability to pass extra _ARG values to fsck, mkfs, and mount.s3ql processes
      - Customizable Config Path and Config File Name
      - Ability to switch on or off Cache including Persistent Cache


## 0.0.1 2023-01-20 <dave at tiredofit dot ca>

   ### Added
      - Initial Release
      - S3QL 4.0.0


