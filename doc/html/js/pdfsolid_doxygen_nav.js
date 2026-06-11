(function () {
  function relativePrefix() {
    var path = window.location.pathname;
    return path.indexOf('/PdfSolidConversion/') !== -1 ? '../' : './';
  }

  function currentPage() {
    var path = window.location.pathname;
    var file = path.substring(path.lastIndexOf('/') + 1) || 'index.html';
    if (path.indexOf('/PdfSolidConversion/') !== -1) {
      return 'modules';
    }
    if (file === 'index.html') {
      return 'main';
    }
    if (file === 'table_of_contents.html') {
      return 'contents';
    }
    return 'modules';
  }

  function tabClass(name, current) {
    return name === current ? ' class="current"' : '';
  }

  function buildTop(prefix, current) {
    return '' +
      '<div id="pdfsolid-doxygen-top">' +
      '  <div id="titlearea">' +
      '    <table cellspacing="0" cellpadding="0"><tbody><tr id="projectrow">' +
      '      <td id="projectlogo"><img alt="Logo" src="' + prefix + 'App.ico"/></td>' +
      '      <td id="projectalign">' +
      '        <div id="projectname">PDFSolid Conversion Ruby SDK<span id="projectnumber">&nbsp;1.1.0</span></div>' +
      '        <div id="projectbrief">API Documentation</div>' +
      '      </td>' +
      '    </tr></tbody></table>' +
      '  </div>' +
      '  <div id="navrow1" class="tabs"><ul class="tablist">' +
      '    <li' + tabClass('main', current) + '><a href="' + prefix + 'index.html"><span>Main&nbsp;Page</span></a></li>' +
      '    <li' + tabClass('modules', current) + '><a href="' + prefix + 'PdfSolidConversion.html"><span>Modules</span></a></li>' +
      '    <li' + tabClass('contents', current) + '><a href="' + prefix + 'table_of_contents.html"><span>Index</span></a></li>' +
      '  </ul></div>' +
      '</div>';
  }

  document.addEventListener('DOMContentLoaded', function () {
    var rdocNav = document.querySelector("nav[role='navigation']");
    if (rdocNav) {
      rdocNav.parentNode.removeChild(rdocNav);
    }

    var top = document.createElement('div');
    top.innerHTML = buildTop(relativePrefix(), currentPage());
    document.body.insertBefore(top.firstChild, document.body.firstChild);
  });
}());
