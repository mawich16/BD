using System;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using static System.Windows.Forms.VisualStyles.VisualStyleElement.StartPanel;

namespace BD
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private string CreateConnectionString(string dbServer, string dbName, string userName, string userPass)
        {
            SqlConnectionStringBuilder builder = new SqlConnectionStringBuilder();

            // Set individual properties of the connection string
            builder.DataSource = dbServer;
            builder.InitialCatalog = dbName;
            builder.UserID = userName;
            builder.Password = userPass;

            return builder.ConnectionString;
        }

        private void TestConnectionButton_Click(object sender, EventArgs e)
        {
            string dbServer = textBox1.Text;
            string dbName = textBox2.Text;
            string userName = textBox2.Text;
            string userPass = textBox3.Text;

            TestDBConnection(dbServer, dbName, userName, userPass);
        }

        private void HelloTableButton_Click(object sender, EventArgs e)
        {
            string dbServer = textBox1.Text;
            string dbName = textBox2.Text;
            string userName = textBox2.Text;
            string userPass = textBox3.Text;

            SqlConnection CN = new SqlConnection(CreateConnectionString(dbServer, dbName, userName, userPass));

            string result = GetTableContent(CN);

            MessageBox.Show( result, "Dump Hello Table", MessageBoxButtons.OK);
        }

        private void TestDBConnection(string dbServer, string dbName, string userName, string userPass)
        {
            SqlConnection CN = new SqlConnection(CreateConnectionString(dbServer, dbName, userName, userPass));

            try
            {
                CN.Open();
                if (CN.State == ConnectionState.Open)
                {
                    MessageBox.Show("Successful connection to database " + CN.Database + " on the "
                   + CN.DataSource + " server", "Connection Test", MessageBoxButtons.OK);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show("Failed to open connection to database due to the error \r\n" +
               ex.Message, "Connection Test", MessageBoxButtons.OK);
            }
            if (CN.State == ConnectionState.Open)
                CN.Close();
        }

        private string GetTableContent(SqlConnection CN)
        {
            string str = "";

            try
            {
                CN.Open();
                if (CN.State == ConnectionState.Open)
                {
                    int cnt = 1;
                    SqlCommand sqlcmd = new SqlCommand("SELECT * FROM Hello", CN);
                    SqlDataReader reader  = sqlcmd.ExecuteReader();
                    while (reader.Read())
                    {
                        str += cnt.ToString() + " - " + reader.GetInt32(reader.GetOrdinal("MsgID")) +
                       ", ";
                        str += reader.GetString(reader.GetOrdinal("MsgSubject"));
                        str += "\n";
                        cnt += 1;
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(" Failed to open connection to database due to the error \r\n" +
               ex.Message, "Connection Error", MessageBoxButtons.OK);
            }

            if (CN.State == ConnectionState.Open)
                CN.Close();
            
            return str;
        }
    }
}
