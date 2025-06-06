// export R# source type define for javascript/typescript language
//
// package_source=WorkflowRender

declare namespace WorkflowRender {
   module _ {
      /**
        * @param ssid default value Is ``null``.
      */
      function get_context(ssid?: any): object;
      /**
      */
      function internal_call(app: any, context: any): object;
      /**
      */
      function onLoad(): object;
   }
   /**
   */
   function __build_app(f: any): object;
   __global_ctx: any;
   /**
     * @param disables default value Is ``Call "list"()``.
   */
   function __runImpl(context: any, disables?: any): object;
   /**
   */
   function __workfile_uri_parser(uri: any): object;
   /**
   */
   function __workfiles(files_uri: any): object;
   /**
     * @param desc default value Is ``no description``.
     * @param dependency default value Is ``null``.
   */
   function app(name: any, analysis: any, desc?: any, dependency?: any): object;
   module app_check {
      /**
      */
      function delegate(analysis: any): object;
      /**
      */
      function signature(app: any): object;
   }
   app_not_registered: any;
   module check_dependency {
      /**
      */
      function context_env(requires: any, context: any): object;
      /**
      */
      function localfiles(requires: any, context: any): object;
   }
   /**
     * @param mounts default value Is ``null``.
     * @param ssid default value Is ``null``.
   */
   function create_memory_context(mounts?: any, ssid?: any): object;
   /**
   */
   function definePipeline(seq: any): object;
   module dependency {
      /**
      */
      function context_env_missing(context: any): object;
      /**
      */
      function workfiles_missing(file: any): object;
   }
   /**
   */
   function dependency_analysis(app: any): object;
   /**
   */
   function dependency_graph(mounts: any): object;
   /**
     * @param app default value Is ``null``.
     * @param ssid default value Is ``null``.
   */
   function echo_warning(msg: any, app?: any, ssid?: any): object;
   /**
   */
   function extract_workflow_vertex(meta: any): object;
   /**
     * @param maxchars default value Is ``48``.
   */
   function filepath_safe(dir: any, filename: any, maxchars?: any): object;
   /**
     * @param ssid default value Is ``null``.
   */
   function finalize(ssid?: any): object;
   /**
   */
   function get_app_name(app: any): object;
   module get_appName {
      /**
      */
      function func_reference(app: any): object;
      /**
      */
      function obj(app: any): object;
   }
   /**
     * @param default default value Is ``null``.
     * @param warn_msg default value Is ``null``.
   */
   function get_config(name: any, default?: any, warn_msg?: any): object;
   /**
   */
   function get_functionName(f: any): object;
   /**
   */
   function get_timestamp(): object;
   /**
   */
   function has_cachefile(filepath: any): object;
   /**
   */
   function hook(app: any): object;
   /**
     * @param outputdir default value Is ``./``.
     * @param ssid default value Is ``null``.
   */
   function init_context(outputdir?: any, ssid?: any): object;
   invalid_app_target: any;
   /**
   */
   function pull_configs(): object;
   /**
     * @param ssid default value Is ``null``.
   */
   function result_dir(ssid?: any): object;
   /**
     * @param registry default value Is ``null``.
     * @param disables default value Is ``Call "list"()``.
   */
   function run(registry?: any, disables?: any): object;
   /**
     * @param configs default value Is ``Call "list"()``.
   */
   function set_config(configs?: any): object;
   /**
     * @param context_env default value Is ``Call "list"()``.
     * @param workfiles default value Is ``Call "list"()``.
   */
   function set_dependency(context_env?: any, workfiles?: any): object;
   /**
     * @param flag default value Is ``true``.
   */
   function set_disable(app: any, flag?: any): object;
   /**
   */
   function summary(): object;
   /**
   */
   function tabulate_workflow_summary(pool: any): object;
   /**
   */
   function throw_err(msg: any): object;
   /**
   */
   function use_cache(filepath: any, create: any): object;
   /**
     * @param ssid default value Is ``null``.
   */
   function workdir_root(ssid?: any): object;
   /**
     * @param relpath default value Is ``null``.
     * @param ssid default value Is ``null``.
   */
   function workfile(app: any, relpath?: any, ssid?: any): object;
   /**
     * @param ssid default value Is ``null``.
   */
   function workspace(app: any, ssid?: any): object;
}
