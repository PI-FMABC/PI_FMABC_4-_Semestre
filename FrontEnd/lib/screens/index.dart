import 'package:flutter/material.dart';
import 'responsive.dart';

class IndexScreen extends StatelessWidget {
  const IndexScreen({super.key});

  void _navigateToRoute(BuildContext context, String routeName) {
    if (ModalRoute.of(context)?.settings.name != routeName) {
      Navigator.pushNamed(context, routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

 
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(Responsive.isMobile(context) ? 70 : 80),
        child: Container(
          color: const Color(0xFF003b64),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: EdgeInsets.only(left: Responsive.isMobile(context) ? 12 : 20),
                child: Row(
                  children: [
                    if (Responsive.isMobile(context) || Responsive.isTablet(context))
                      Builder(
                        builder: (context) => IconButton(
                          icon: const Icon(Icons.menu, color: Colors.white),
                          onPressed: () => Scaffold.of(context).openDrawer(),
                        ),
                      ),
                    Image.asset(
                      'lib/assets/logo.png',
                      height: Responsive.isMobile(context) ? 45 : 55,
                      errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                    ),
                    SizedBox(width: Responsive.isMobile(context) ? 6 : 10),
                    Responsive.isMobile(context)
                        ? const Text(
                            "Atlas",
                            style: TextStyle(
                              color: Color(0xFF009245),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : const Text(
                            "Atlas de Histologia",
                            style: TextStyle(
                              color: Color(0xFF009245),
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ],
                ),
              ),
              if (Responsive.isDesktop(context))
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pushNamed(context, '/login'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF003b64),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.person),
                    label: const Text("Login"),
                  ),
                ),
            ],
          ),
        ),
      ),

   
      drawer: (Responsive.isMobile(context) || Responsive.isTablet(context)) 
          ? _buildDrawer(context) 
          : null,

    
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Responsive.isMobile(context) ? 16 : 24,
            vertical: Responsive.isMobile(context) ? 16 : 20,
          ),
          child: Column(
            children: [
      
              if (Responsive.isDesktop(context))
                Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFe5e5e5),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildMenuButton(context, "Home",
                            onTap: () => Navigator.pushNamed(context, '/')),
                        _buildMenuButton(context, "Tópicos",
                            onTap: () => Navigator.pushNamed(context, '/folders')),
                        _buildMenuButton(context, "Galeria",
                            onTap: () => Navigator.pushNamed(context, '/gallery')),
                        _buildMenuButton(context, "Índice", isActive: true),
                      ],
                    ),
                  ),
                ),

              if (Responsive.isDesktop(context)) const SizedBox(height: 28),

           
              Responsive.isMobile(context)
                  ? _buildMobileLayout(context)
                  : _buildDesktopLayout(context),

              const SizedBox(height: 36),

           
              Center(
                child: Text(
                  "© ${DateTime.now().year} FMABC — Atlas Digital de Citologia",
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: Responsive.isMobile(context) ? 12 : 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

 
  Widget _buildMobileLayout(BuildContext context) {
    return Column(
      children: [
  
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Índice de Imagens",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF003b64),
                ),
              ),
              const Divider(thickness: 1),
              Wrap(
                spacing: 8,
                children: [
                  _buildIndexChip("#AA"),
                  _buildIndexChip("#BB"),
                  _buildIndexChip("#CC"),
                  _buildIndexChip("#DD"),
                  _buildIndexChip("#EE"),
                ],
              ),
            ],
          ),
        ),

 
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.9,
          ),
          itemCount: 12,
          itemBuilder: (context, index) {
            return _buildImageItem(context, index);
          },
        ),
      ],
    );
  }

 
  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
    
        Container(
          width: Responsive.isTablet(context) ? 180 : 200,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Índice de Imagens",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF003b64),
                ),
              ),
              const Divider(thickness: 1),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text("#AA"),
                onTap: () {},
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text("#BB"),
                onTap: () {},
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text("#CC"),
                onTap: () {},
              ),
            ],
          ),
        ),

        SizedBox(width: Responsive.isTablet(context) ? 16 : 20),

   
        Expanded(
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: Responsive.isTablet(context) ? 3 : 4,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1,
            ),
            itemCount: 12,
            itemBuilder: (context, index) {
              return _buildImageItem(context, index);
            },
          ),
        ),
      ],
    );
  }


  Widget _buildImageItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: () => Navigator.pushNamed(context, '/image-viewer'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: const Color(0xFF003b64)),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.all(Responsive.isMobile(context) ? 8 : 10),
        child: Column(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.asset(
                  'assets/folder_image.png',
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Icon(
                    Icons.image_outlined,
                    color: const Color(0xFF003b64),
                    size: Responsive.isMobile(context) ? 30 : 40,
                  ),
                ),
              ),
            ),
            SizedBox(height: Responsive.isMobile(context) ? 6 : 8),
            Text(
              "Imagem ${index + 1}",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: Responsive.isMobile(context) ? 12 : 14,
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildIndexChip(String label) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.white,
      side: BorderSide(color: Colors.grey.shade400),
    );
  }

 
  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color(0xFF003b64),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Atlas de Histologia',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Navegação',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              _navigateToRoute(context, '/');
            },
          ),
          ListTile(
            leading: const Icon(Icons.folder),
            title: const Text('Tópicos'),
            onTap: () {
              Navigator.pop(context);
              _navigateToRoute(context, '/folders');
            },
          ),
          ListTile(
            leading: const Icon(Icons.image),
            title: const Text('Galeria'),
            onTap: () {
              Navigator.pop(context);
              _navigateToRoute(context, '/gallery');
            },
          ),
          ListTile(
            leading: const Icon(Icons.list),
            title: const Text('Índice'),
            onTap: () {
              Navigator.pop(context);
              _navigateToRoute(context, '/index');
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Login'),
            onTap: () {
              Navigator.pop(context);
              _navigateToRoute(context, '/login');
            },
          ),
        ],
      ),
    );
  }


  Widget _buildMenuButton(BuildContext context, String label,
      {bool isActive = false, VoidCallback? onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFF003b64) : Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.white : Colors.black,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}