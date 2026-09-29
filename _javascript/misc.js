import { basic, initSidebar, initTopbar } from './modules/layouts';
import { initLocaleDatetime } from './modules/plugins';

initSidebar();
initTopbar();
initLocaleDatetime();
basic();

function initSortableTables() {
  document.querySelectorAll('table.sortable').forEach((table) => {
    table.querySelectorAll('th[data-sort]').forEach((th) => {
      th.style.cursor = 'pointer';
      th.addEventListener('click', () => {
        const tbody = table.querySelector('tbody');
        const rows = Array.from(tbody.querySelectorAll('tr'));
        const index = Array.from(th.parentNode.children).indexOf(th);
        const type = th.dataset.sort;
        const asc = th.dataset.dir !== 'asc';
        th.dataset.dir = asc ? 'asc' : 'desc';
        rows.sort((a, b) => {
          const av = a.children[index].dataset.sortValue || '';
          const bv = b.children[index].dataset.sortValue || '';
          let cmp;
          if (type === 'number') cmp = parseFloat(av) - parseFloat(bv);
          else cmp = av.localeCompare(bv);
          return asc ? cmp : -cmp;
        });
        rows.forEach((r) => tbody.appendChild(r));
      });
    });
  });
}

initSortableTables();
