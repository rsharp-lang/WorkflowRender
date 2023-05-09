// export R# source type define for javascript/typescript language
//
// package_source=WorkflowRender

declare namespace WorkflowRender {
   /**
     * @param desc default value Is ``"no description"``.
   */
   function app(name:any, analysis:any, desc:string): object;
   /**
   */
   function set_config(configs:any): object;
   /**
     * @param outputdir default value Is ``"./"``.
   */
   function init_context(outputdir:string): object;
   /**
   */
   function finalize(): object;
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
   function hook(app:any): object;
   /**
   */
   function echo_warning(msg:any): object;
   /**
     * @param registry default value Is ``NULL``.
   */
   function run(registry:any): object;
   /**
   */
   function __runImpl(context:any): object;
   /**
   */
   function workspace(app:any): object;
}
