namespace SettingsMenu
{
    partial class Form1
    {
        /// <summary>
        /// Variable del diseñador necesaria.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Limpiar los recursos que se estén usando.
        /// </summary>
        /// <param name="disposing">true si los recursos administrados se deben desechar; false en caso contrario.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Código generado por el Diseñador de Windows Forms

        /// <summary>
        /// Método necesario para admitir el Diseñador. No se puede modificar
        /// el contenido de este método con el editor de código.
        /// </summary>
        private void InitializeComponent()
        {
            this.labelTitulo = new System.Windows.Forms.Label();
            this.labelResolucion = new System.Windows.Forms.Label();
            this.buttonInicio = new System.Windows.Forms.Button();
            this.comboBoxResolucion = new System.Windows.Forms.ComboBox();
            this.comboBoxMode = new System.Windows.Forms.ComboBox();
            this.labelDisplay = new System.Windows.Forms.Label();
            this.buttonCerrar = new System.Windows.Forms.Button();
            this.SuspendLayout();
            // 
            // labelTitulo
            // 
            this.labelTitulo.AutoSize = true;
            this.labelTitulo.Font = new System.Drawing.Font("Microsoft Sans Serif", 15.75F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.labelTitulo.ForeColor = System.Drawing.Color.Coral;
            this.labelTitulo.Location = new System.Drawing.Point(1, 9);
            this.labelTitulo.Name = "labelTitulo";
            this.labelTitulo.Size = new System.Drawing.Size(223, 25);
            this.labelTitulo.TabIndex = 0;
            this.labelTitulo.Text = "Cavando con Calvin";
            // 
            // labelResolucion
            // 
            this.labelResolucion.AutoSize = true;
            this.labelResolucion.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.labelResolucion.ForeColor = System.Drawing.Color.Coral;
            this.labelResolucion.Location = new System.Drawing.Point(109, 444);
            this.labelResolucion.Name = "labelResolucion";
            this.labelResolucion.Size = new System.Drawing.Size(192, 20);
            this.labelResolucion.TabIndex = 1;
            this.labelResolucion.Text = "Resolución de pantalla";
            // 
            // buttonInicio
            // 
            this.buttonInicio.FlatStyle = System.Windows.Forms.FlatStyle.Flat;
            this.buttonInicio.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.buttonInicio.ForeColor = System.Drawing.SystemColors.ButtonFace;
            this.buttonInicio.Location = new System.Drawing.Point(242, 516);
            this.buttonInicio.Name = "buttonInicio";
            this.buttonInicio.Size = new System.Drawing.Size(176, 32);
            this.buttonInicio.TabIndex = 2;
            this.buttonInicio.Text = "Iniciar juego";
            this.buttonInicio.UseVisualStyleBackColor = true;
            this.buttonInicio.Click += new System.EventHandler(this.button1_Click);
            // 
            // comboBoxResolucion
            // 
            this.comboBoxResolucion.DropDownStyle = System.Windows.Forms.ComboBoxStyle.DropDownList;
            this.comboBoxResolucion.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.comboBoxResolucion.FormattingEnabled = true;
            this.comboBoxResolucion.Items.AddRange(new object[] {
            "1280x720",
            "1920x1080"});
            this.comboBoxResolucion.Location = new System.Drawing.Point(405, 443);
            this.comboBoxResolucion.Name = "comboBoxResolucion";
            this.comboBoxResolucion.Size = new System.Drawing.Size(149, 21);
            this.comboBoxResolucion.TabIndex = 3;
            this.comboBoxResolucion.SelectedIndexChanged += new System.EventHandler(this.comboBoxResolucion_SelectedIndexChanged);
            // 
            // comboBoxMode
            // 
            this.comboBoxMode.Font = new System.Drawing.Font("Microsoft Sans Serif", 8.25F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.comboBoxMode.FormattingEnabled = true;
            this.comboBoxMode.Items.AddRange(new object[] {
            "FullScreen",
            "Windowed"});
            this.comboBoxMode.Location = new System.Drawing.Point(405, 406);
            this.comboBoxMode.Name = "comboBoxMode";
            this.comboBoxMode.Size = new System.Drawing.Size(149, 21);
            this.comboBoxMode.TabIndex = 5;
            this.comboBoxMode.Text = "Windowed";
            // 
            // labelDisplay
            // 
            this.labelDisplay.AutoSize = true;
            this.labelDisplay.Font = new System.Drawing.Font("Microsoft Sans Serif", 12F, System.Drawing.FontStyle.Bold, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.labelDisplay.ForeColor = System.Drawing.Color.Coral;
            this.labelDisplay.Location = new System.Drawing.Point(109, 406);
            this.labelDisplay.Name = "labelDisplay";
            this.labelDisplay.Size = new System.Drawing.Size(116, 20);
            this.labelDisplay.TabIndex = 4;
            this.labelDisplay.Text = "Display Mode";
            // 
            // buttonCerrar
            // 
            this.buttonCerrar.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Center;
            this.buttonCerrar.FlatStyle = System.Windows.Forms.FlatStyle.Popup;
            this.buttonCerrar.Font = new System.Drawing.Font("Microsoft Sans Serif", 21.75F, System.Drawing.FontStyle.Regular, System.Drawing.GraphicsUnit.Point, ((byte)(0)));
            this.buttonCerrar.ForeColor = System.Drawing.SystemColors.ButtonFace;
            this.buttonCerrar.Location = new System.Drawing.Point(596, 12);
            this.buttonCerrar.Name = "buttonCerrar";
            this.buttonCerrar.Size = new System.Drawing.Size(56, 40);
            this.buttonCerrar.TabIndex = 6;
            this.buttonCerrar.Text = "X";
            this.buttonCerrar.UseVisualStyleBackColor = true;
            this.buttonCerrar.Click += new System.EventHandler(this.buttonCerrar_Click);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.BackColor = System.Drawing.Color.Black;
            this.BackgroundImage = global::SettingsMenu.Properties.Resources.menu_2;
            this.BackgroundImageLayout = System.Windows.Forms.ImageLayout.Zoom;
            this.ClientSize = new System.Drawing.Size(664, 656);
            this.Controls.Add(this.buttonCerrar);
            this.Controls.Add(this.comboBoxMode);
            this.Controls.Add(this.labelDisplay);
            this.Controls.Add(this.comboBoxResolucion);
            this.Controls.Add(this.buttonInicio);
            this.Controls.Add(this.labelResolucion);
            this.Controls.Add(this.labelTitulo);
            this.DoubleBuffered = true;
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.None;
            this.Name = "Form1";
            this.StartPosition = System.Windows.Forms.FormStartPosition.CenterScreen;
            this.Text = "Cavando con Calvin";
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion

        private System.Windows.Forms.Label labelTitulo;
        private System.Windows.Forms.Label labelResolucion;
        private System.Windows.Forms.Button buttonInicio;
        private System.Windows.Forms.ComboBox comboBoxResolucion;
        private System.Windows.Forms.ComboBox comboBoxMode;
        private System.Windows.Forms.Label labelDisplay;
        private System.Windows.Forms.Button buttonCerrar;
    }
}

