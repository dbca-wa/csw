# Generated by Django 2.1 on 2018-08-09 03:25

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('catalogue', '0002_auto_20180802_0524'),
    ]

    operations = [
        migrations.AlterField(
            model_name='applicationlayer',
            name='layer',
            field=models.ForeignKey(limit_choices_to={'active': True}, on_delete=django.db.models.deletion.PROTECT, to='catalogue.Record'),
        ),
    ]
