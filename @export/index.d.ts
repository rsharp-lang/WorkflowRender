// export R# source type define for javascript/typescript language
//
// package_source=WorkflowRender

declare namespace WorkflowRender {
   module _ {
      /**
      */
      function get_context(): object;
      /**
      */
      function onLoad(): object;
   }
   /**
   */
   function __runImpl(context:any): object;
   /**
     * @param desc default value Is ``"no description"``.
   */
   function app(name:any, analysis:any, desc:string): object;
   /**
   */
   function echo_warning(msg:any): object;
   /**
   */
   function finalize(): object;
   /**
   */
   function hook(app:any): object;
   /**
     * @param outputdir default value Is ``"./"``.
   */
   function init_context(outputdir:string): object;
   /**
     * @param registry default value Is ``NULL``.
   */
   function run(registry:any): object;
   /**
   */
   function set_config(configs:any): object;
   /**
   */
   function workspace(app:any): object;
}
