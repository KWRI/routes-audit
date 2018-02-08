# What is Kong Routes Audit plugin

**routes-audit** is a plugin for [Kong](https://github.com/Mashape/kong) that provides an audit functionalites over APIs routes (addition/deletion).

It does so, by utilizing Kong hooks, and subscribing to its DAO events. This plugin maintains a set of custom entities and provides endpoints that exposes the audit data.
