using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SettingsMenu.Clase
{
    public class Ajustes
    {

        public static List<Ajustes> listaAjustes = new List<Ajustes>();
        private string resolucion;
        private string displayMode;

        public Ajustes(string resolucion, string displayMode)
        {
            this.resolucion = resolucion;
            this.displayMode = displayMode;
        }

        public Ajustes()
        {
        }

        public string Resolucion { get => resolucion; set => resolucion = value; }
        public string DisplayMode { get => displayMode; set => displayMode = value; }
    }
}
