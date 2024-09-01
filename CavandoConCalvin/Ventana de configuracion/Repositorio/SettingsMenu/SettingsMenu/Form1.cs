using SettingsMenu.Clase;
using SettingsMenu.Controlador;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Diagnostics;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace SettingsMenu
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
            comboBoxResolucion.SelectedItem = "Windowed";
            comboBoxMode.SelectedItem = "1280x720";
        }
        private void button1_Click(object sender, EventArgs e)
        {
            // Ruta relativa al archivo ejecutable (si se encuentra en la misma carpeta que la aplicación)
            string rutaEjecutable = @"Calvin.exe";

            // Verificar si el archivo ejecutable existe
            if (System.IO.File.Exists(rutaEjecutable))
            {
                // Obtener la resolución seleccionada del ComboBox
                string resolucionSeleccionada = comboBoxResolucion.SelectedItem.ToString();
                string modeSeleccionado = comboBoxMode.SelectedItem.ToString();
                // Crear un nuevo objeto Ajustes y agregarlo a la lista de ajustes
                Clase.Ajustes ajustes = new Clase.Ajustes(resolucionSeleccionada, modeSeleccionado);
                Clase.Ajustes.listaAjustes.Add(ajustes);

                try
                {
                    Controlador.ControladorArchivos.guardarJSON();
                    Console.WriteLine("Ajustes guardados correctamente.");
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Error al guardar los ajustes: " + ex.Message);
                }

                // Ejecutar el archivo
                Process.Start(rutaEjecutable);
                this.Close();
            }
            else
            {
                MessageBox.Show("El archivo ejecutable no se encontró.", "Error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }
        }

        private void buttonCerrar_Click(object sender, EventArgs e)
        {
            this.Close();
        }

        private void comboBoxResolucion_SelectedIndexChanged(object sender, EventArgs e)
        {

        }
    }
}
