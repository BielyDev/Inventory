# Sobre.

 -Versão 0.9.0.
  
 -Este projeto é apenas compativel com a versão da Godot Engine 3.5.x.


# Como usar?

  -Adicione o Inventory.gd (```res://Addons/Inventory_Template/Scripts/Autoload/Inventory.gd```) a um autoload
do projeto :```Project Settings>Singletons```

    
![image](https://github.com/BielyDev/Inventory_Template/assets/71566495/8f8114b9-1eae-4bf6-b498-31659103ce0e)


  -As cenas de inventarios já estão prontas para uso, adicione a sua cena e pronto!

  
![image](https://github.com/BielyDev/Inventory_Template/assets/71566495/0b3f04ff-eb52-404d-854b-33dac98c1491)


# Como criar um item?

 -Criar um item é bem simples, em ```res://Addons/Inventory_Template/Scenes/Itens``` existem modelos e 
estruturas prontas, aproveite e as copie e cole para uma cena nova.


![image](https://github.com/BielyDev/Inventory_Template/assets/71566495/6c7220a4-fcd3-4ca9-a3dc-e9a6ea054030)


 -Após isto configure o item do seu jeito.
```Obs: Nodes 3D também funcionam poís o item extende a classe "Node".```

# Como saber se um item foi equipado?

 -Em Inventory.gd (Script em Autoload) existem sinais importantes para a estrutura do inventário.


![image](https://github.com/BielyDev/Inventory_Template/assets/71566495/1fd61421-0291-4ca9-9e88-0e5e6790e242)


   -O argumento "item_dictionary" em casos de qualquer item ser equipado receberá o item em dicionario, conecte
  ao seu script usando ```Inventory.connect("equipped_item",objeto,"sua função")```.


![image](https://github.com/BielyDev/Inventory_Template/assets/71566495/473cb6c7-1e9b-46bf-9081-f05e7fb816f0)


  -O mesmo caso acontece com o desequipar, use ```Inventory.connect("unequip_item",objeto,"sua função")```.


# Criar categorias de equipamentos.

  -O projeto já vem com algumas categorias em ```Inventory.gd```:

 ![Captura de tela de 2023-10-27 09-26-48](https://github.com/BielyDev/Inventory_Template/assets/71566495/713d89a7-7934-4ad6-b211-ef03b007235c)

  -Basta remover ou adicionar suas proprias categorias no enumerado ```TYPE```:

 ![Captura de tela de 2023-10-27 09-29-58](https://github.com/BielyDev/Inventory_Template/assets/71566495/6668bba2-f8bf-467a-b0f4-bfac5239e1d3)

 -Após editar o ```TYPE``` reinicie o projeto para que os itens e slots atualizem sua lista de categorias.

 ![Captura de tela de 2023-10-27 09-39-47](https://github.com/BielyDev/Inventory_Template/assets/71566495/cd9fd68f-c163-4d91-a37a-a11807e4a45a)
