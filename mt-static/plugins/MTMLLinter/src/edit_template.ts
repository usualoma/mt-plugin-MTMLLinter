const template = document.querySelector<HTMLTemplateElement>("#mtml-linter-alert")?.content.firstElementChild as HTMLElement;
const placeholder = document.querySelector("#template-listing-form");

function checkRule(ast) {
  ast.children.forEach((node) => {
    if (node.children) {
      checkRule(node);
      return;
    }

    if ((node.name || "").match(/var/i)) {
      let hasValue = false;
      let hasEscape = false;
      node.attributes.forEach((attr) => {
        hasValue ||= attr.name === "value";
        hasEscape ||= attr.name.match(/^(escape|encode)/i);
      });
      if (!hasValue && !hasEscape) {
        const alert = template.cloneNode(true) as HTMLElement;
        const msg = alert.querySelector(".mtml-linter-alert__message");
        if (msg) {
          msg.textContent = `mt:Var がエスケープされていません。(${node.line}, ${node.column})`;
        }
        placeholder?.parentElement?.insertBefore(alert, placeholder);
      }
    }
  });
}

window.invokeMTMLLinter = function (ast) {
  document.querySelectorAll(".mtml-linter-alert").forEach((el) => el.remove());
  checkRule(ast);
};
